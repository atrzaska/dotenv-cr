# Dotenv-cr

Dotenv is a application to load your dotenv files from current working directory into environment and provide environment variables to other programs.

The software was designed to help load environment variables in Rails applications, but is not limited to Rails.

This project is a crystal implementation of the ruby version https://github.com/atrzaska/dotenv.

## Examples:

Add environment variables in the `.env` files of your project

    touch .env
    touch .env.test
    touch .env.development
    touch .env.preview
    touch .env.staging
    touch .env.production
    touch .env.local
    touch .env.test.local
    touch .env.development.local
    touch .env.preview.local
    touch .env.staging.local
    touch .env.production.local

Run your software

    dotenv env
    dotenv test bundle exec rspec
    dotenv bundle exec rails s
    dotenv exec env
    dotenv -f my_custom_env_file exec env
    dotenv -f my_custom_env_file env

## Development requirements

- Crystal (Tested on 1.4.1)

## Setup

The setup is as simple as downloading the binary

    git clone https://github.com/atrzaska/dotenv-cr
    cd dotenv-cr
    make
    ./dotenv

Ideally you should add dotenv to your PATH environment variable or move it to some location in PATH. That will make using the program a lot easier.

You can also create some aliases to avoid typing dotenv every time.

    alias be='dotenv bundle exec'
    alias dot=dotenv

## Docker setup

the prebuilt image is published at https://hub.docker.com/r/andrzejtrzaska/dotenv

## Environment integrations

Dotenv uses `RAILS_ENV` **or** `ENV` environment variable to load correct environment file.

For example for `RAILS_ENV=development` or `ENV=development` it will load in order:

- `.env`
- `.env.development`
- `.env.local`
- `.env.development.local`

Default environment is `development`.

## Notes

### Override environment variables

Unlike normal dotenv, it is **possible to override** already set environment variables.

### Comments

It is possible to comment out some environment variables in dotfiles. To comment out a variable, **use the `#` character**:

    # NODE_ENV=development

### Exports

To provide copy paste support from shell scripts, **`export` keywords will be ignored**, when reading dotenv files.

With that said, **both versions** of following environment variable definition **will work** just fine:

- Dotenv syntax


    `NODE_ENV=development`

- Shell export syntax


    `export NODE_ENV=development`

## Licence

MIT

