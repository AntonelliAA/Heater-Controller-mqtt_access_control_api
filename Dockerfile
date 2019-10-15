# pull official base image
FROM python:3.7.4-alpine

# set work directory
WORKDIR /usr/src/mqtt_access_control_api

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && pip install psycopg2 \
    && apk del build-deps

# install dependencies
RUN pip install --upgrade pip
RUN pip install pipenv
COPY ./Pipfile /usr/src/mqtt_access_control_api/Pipfile
RUN pipenv install --skip-lock --system --dev

# copy project
COPY . /usr/src/mqtt_access_control_api/

# copy entrypoint.sh
COPY ./entrypoint.sh /usr/src/mqtt_access_control_api/entrypoint.sh

RUN chmod +x /usr/src/mqtt_access_control_api/entrypoint.sh

RUN ls /usr/src/mqtt_access_control_api/

# run entrypoint.sh
ENTRYPOINT ["/usr/src/mqtt_access_control_api/entrypoint.sh"]

EXPOSE 8001

CMD ["python", "manage.py", "runserver", "0:8001"]
