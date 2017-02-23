# LabQLite Model Generator
Used to generate model class files for use with the [LabQLite](https://github.com/jmbarnardgh/labqlite) library.

## How to Use

- Download or clone this repository.
- Use `labqlitemodelgen.sh` to generate your model classes based on your SQLite 3 database file, like so:

```shell
./labqlitemodelgen.sh SQLite_database_file_path output_directory
```

Provided that `SQLite_database_file_path` is a path to a valid SQLite 3 database, the LabQLite Model Generator shell script will generate `.h` and `.m` file pairs comprising your new model classes to be used with [LabQLite](https://github.com/jmbarnardgh/labqlite).

## Licensing
![Public Domain](public_domain_logo.png "Public Domain")

**LabQLite Model Generator** is in the Public Domain. See the `LICENSE` file in the root directory of this repository.