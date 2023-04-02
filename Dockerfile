FROM debian:stable

ENV DEBIAN_FRONTEND noninteractive

# install some stuff
RUN apt-get update && apt-get -y install \
      curl \
      # fontconfig \
      # gnuplot \
      # libfontconfig1 \
      perl \
      wget \
      && rm -rf /var/lib/apt/lists/*

# args (can be overridden from docker build cli)
ARG YEAR=2023
ARG SCRIPT_DIR=install-tl
ARG SCHEME=minimal

# install texlive package
RUN mkdir tmp-tex
WORKDIR tmp-tex
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN zcat < install-tl-unx.tar.gz | tar xf -
RUN mv $(find . -type d -name 'install-tl-*') $SCRIPT_DIR
WORKDIR $SCRIPT_DIR
RUN perl ./install-tl --no-interaction --scheme=$SCHEME
RUN echo "export PATH='/usr/local/texlive/$YEAR/bin/x86_64-linux:$PATH'" >> ~/.bashrc

# install latexmk
RUN ["/bin/bash", "-c", "source $HOME/.bashrc && tlmgr install latexmk"]

WORKDIR /home
ADD entry.sh /home
RUN chmod a+x entry.sh
ENTRYPOINT ["/bin/bash", "-c", "/home/entry.sh"]
