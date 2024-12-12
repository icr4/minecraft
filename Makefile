ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)

all: priv/nifs.so

priv/nifs.so: src/nifs.c src/perlin.c src/chunk.c src/biome.c
	cc -Wall -Wextra -Wpedantic -O3 -fPIC -std=c99 -I$(ERL_INCLUDE_PATH)/include -bundle -bundle_loader $(ERL_INCLUDE_PATH)/bin/beam.smp -o priv/nifs.so src/nifs.c src/perlin.c src/chunk.c src/biome.c
