FROM debian:stable

# args (can be overridden from docker build cli)
ENV DEBIAN_FRONTEND noninteractive
ARG YEAR=2023
ARG SCRIPT_DIR=install-tl
ARG SCHEME=minimal

# set shell to bash
SHELL ["/bin/bash", "-c"]

# install some stuff
RUN apt-get update && apt-get -y install \
  curl \
  fontconfig \
  gnuplot \
  libfontconfig1 \
  perl \
  texlive-latex-recommended \
  texlive-luatex \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN ls /usr/local

# install texlive package
RUN mkdir tmp-tex
WORKDIR tmp-tex
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN zcat < install-tl-unx.tar.gz | tar xf -
RUN mv $(find . -type d -name 'install-tl-*') $SCRIPT_DIR
WORKDIR $SCRIPT_DIR
RUN perl ./install-tl --no-interaction --scheme=$SCHEME

# export path to sh rc
WORKDIR /root
RUN echo "export PATH='/usr/local/texlive/$YEAR/bin/x86_64-linux:$PATH'" >> ~/.bashrc

# install latexmk
RUN source ~/.bashrc \
  && tlmgr init-usertree \
  && tlmgr update --self \
  && tlmgr install latexmk

WORKDIR /root
ADD entry.sh ./
RUN chmod a+x entry.sh

WORKDIR /data
ENTRYPOINT ["/root/entry.sh"]
