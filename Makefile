install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

lint:
	hadolint Dockerfile
	pylint --disable=R,C,W1203 app.py

build:
	docker build --tag=agrinshpon/udacity-capstone

all: install lint build
