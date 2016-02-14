FROM ubuntu
WORKDIR /code
RUN apt-get install -y git-core libyaml-dev curl python

RUN useradd -ms /bin/bash deploy
RUN /bin/bash -l -c "echo 'deploy   ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers"
USER deploy

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -l -c "source /home/deploy/.rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm reload"
RUN /bin/bash -l -c "rvm install 2.2.2"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install jekyll --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install therubyracer --no-ri --no-rdoc"
RUN /bin/bash -l -c "rvm use 2.2.2"
ADD . /code

ONBUILD ENV USER deploy
ONBUILD RUN /bin/bash -l -c "source /home/$USER/.rvm/scripts/rvm"
EXPOSE 4000
