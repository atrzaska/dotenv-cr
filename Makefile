all: clean build

build:
	crystal build dotenv.cr

release:
	crystal build --release --static dotenv.cr

clean:
	rm dotenv dotenv.dwarf || true
