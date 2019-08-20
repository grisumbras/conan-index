#!/usr/bin/env python3


from mako.template import Template
from mako.runtime import Context
from pathlib import Path
import sys
import json


class Remote(object):
    def __init__(self, name, url, packages):
        self.name = name
        self.url = url
        self.packages = packages


def get_data(remotes, packages):
    packages = json.load(packages)["results"]
    remotes = json.load(remotes)["remotes"]
    result = list()
    for remote in packages:
        remote_name = remote["remote"]
        remote_url = [r["url"] for r in remotes if r["name"] == remote_name][0]
        result.append(Remote(
            name=remote_name,
            url=remote_url,
            packages=remote["items"]
        ))
    result = sorted(result, key=lambda r: r.name)
    return result


def main():
    with open("packages.json", "r") as packages:
        with open(Path.home() / ".conan" / "remotes.json", "r") as remotes:
            data = get_data(remotes, packages)
    context = Context(sys.stdout, data=data)
    template = Template(filename="index.mako", output_encoding="utf-8")
    template.render_context(context)


if __name__ == "__main__":
    main()
