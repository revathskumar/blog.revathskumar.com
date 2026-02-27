---
layout: post
title: hide your dotenv secrets from LLMs using pass
date: 2026-02-27 18:02 CEST
updated: 2026-02-27 18:02 CEST
categories: bash
tags: bash pass dotenv llm
image: ''
---
I have been using [pass](https://www.passwordstore.org/) for a while to avoid credentials being saved into CLI history.

```sh
AWS_SECRET=$(pass show project/dev/aws_secret) <command>
```

After reading about [enveil](https://github.com/GreatScott/enveil) project, I thought, rather than adding another tool into my arsenal, Why don't I just use the tools I already have?

> TLDR: The pass extension and setup instructions can be found in the [pass-env](https://codeberg.org/0x52534B/pass-env) Codeberg repository.

<!--excerpt ends-->
## <a class="anchor" name="the-bash-script" href="#the-bash-script"><i class="anchor-icon"></i></a>the bash script

The script below will reads the `.env` file and uses the `pass` command to retrieve the real secret at the time of execution. This means that even if we give the LLM access to the project folder, the real credentials will remain hidden from LLM agents.

```bash
#!/bin/bash
# exec 1> >(logger -s -t $(basename $0)) 2>&1;

ENV_FILE=".env"

# if command -v pass >/dev/null 2>&1 ; then
#     echo "Error: passwordstore/pass not found!"
#     exit 1
# fi

while [[ $# -gt 0 ]]; do
  case $1 in
    --env-file)
      ENV_FILE="$2"
      shift 2
      ;;
    --)
      shift 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found!"
  exit 1
fi

while IFS='=' read -r key value; do
  [[ -z "$key" || "$key" =~ ^# ]] && continue

  if [[ "$value" == pass://* ]]; then
    path="${value#pass://}"
    secret=$(pass show "$path" 2>/dev/null)
    if [[ -z "$secret" ]]; then
      echo "Error: Failed to retrieve secret for $key"
      continue
    fi
  else
    secret=$value
  fi

  # echo "$key=$secret"
  export "$key=$secret"
done < "$ENV_FILE"

if [[ $# -gt 0 ]]; then
    "$@" || exit
else
  echo "Usage: $0 [--env-file <env-file>] -- <command>"
  exit 1
fi

```

The `.env` file should be in the following format

```env
AWS_SECRET=pass://<pass-name>
```

The script looks for values beginning with 'pass://' and attempts to retrieve the real secret from 'pass' before setting it as an environment variable and running the given command.

For example, if the .env file contains an entry such as

```env
AWS_SECRET=pass://pass-env/dev/aws_secret
```

the shell script will run the following command to retrieve the secret from pass.

```sh
pass show pass-env/dev/aws_secret
```

Env variable values that don't start with `pass://` will be taken as they are.

## <a class="anchor" name="using-the-bash-script" href="#using-the-bash-script"><i class="anchor-icon"></i></a>Using the bash script

Copy the `env.bash` into any folder you have in `PATH` or to the pass extensions folder.

```sh
env.bash -- <command>
#or
pass env -- <command> # as pass extension
```

If you want to use a custom `.env` file you can pass it via `--env-file` option.

```sh
env.bash --env-file .env.prod -- <command>
#or
pass env --env-file .env.prod -- <command>
```

The pass extension and setup instructions can be found in the [pass-env](https://codeberg.org/0x52534B/pass-env) Codeberg repository.

Hope this is helpful.  
Any feedback would be much appreciated.
