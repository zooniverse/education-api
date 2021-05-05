FROM ruby:2.6-stretch

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y git curl supervisor libpq-dev  && \
    apt-get clean

ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/

RUN bundle install

ADD supervisord.conf /etc/supervisor/conf.d/app.conf
ADD ./ /app

RUN (cd /app && git log --format="%H" -n 1 > commit_id.txt && rm -rf .git)

EXPOSE 80

CMD ["/app/scripts/docker/start.sh"]
