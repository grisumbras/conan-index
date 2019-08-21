#!/usr/bin/env python3


from mako.template import Template
from mako.runtime import Context
from pathlib import Path
import json
import re
import subprocess
import sys


class Remote(object):
    def __init__(self, name, url):
        self.name = name
        self.url = url
        self.packages = list()

    def __lt__(self, other):
        return self.name < other.name

    def __le__(self, other):
        return self.name <= other.name

    def __eq__(self, other):
        return self.name == other.name


class Package(object):
    def __init__(self, name, version, namespace, channel, remote):
        self.name = name
        self.version = version
        self.namespace = namespace
        self.channel = channel
        self.remote = remote

    def reference(self):
        return "%s/%s@%s/%s" % (
            self.name, self.version, self.namespace, self.channel
        )

    def _struct(self):
        return (self.name, self.namespace, self.version, self.channel)

    def __lt__(self, other):
        return self._struct() < other._struct()

    def __le__(self, other):
        return self._struct() <= other._struct()

    def __eq__(self, other):
        return self._struct() == other._struct()


class PackageGroup(object):
    def __init__(self, name, namespace):
        self.name = name
        self.namespace = namespace
        self.packages = list()

    def load_info(self):
        package = self.packages[0]
        subprocess.call(
            (
                "conan",
                "inspect",
                "-r", package.remote.name,
                "-j", "/tmp/package.json",
                package.reference(),
            ),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        with open("/tmp/package.json", "r") as package_file:
            data = json.load(package_file)
            self.url = data["url"]
            self.homepage = data["homepage"]
            self.license = data["license"]
            self.author = data["author"]
            self.description = data["description"]
            self.topics = data["topics"]

    def _struct(self):
        return (self.name, self.namespace)

    def __lt__(self, other):
        return self._struct() < other._struct()

    def __le__(self, other):
        return self._struct() <= other._struct()

    def __eq__(self, other):
        return self._struct() == other._struct()


def get_remotes(remotes_file):
    remotes_data = json.load(remotes_file)["remotes"]
    return dict((
        (remote["name"], Remote(name=remote["name"], url=remote["url"]))
        for remote in remotes_data
    ))


def get_packages(packages_file, remotes):
    packages_data = json.load(packages_file)["results"]

    pattern = re.compile("^([-\w.]+)/([-\w.]+)@([-\w.]+)/([-\w.]+)$")
    result = list()
    for remote_data in packages_data:
        remote = remotes[remote_data["remote"]]
        for package_data in remote_data["items"]:
            match = pattern.match(package_data["recipe"]["id"])
            if not match:
                continue
            result.append(Package(
                *match.groups(),
                remote=remote,
            ))
    return result


def group_packages(packages):
    groups = dict()
    for package in packages:
        group_id = (package.name, package.namespace)
        group = groups.setdefault(group_id, PackageGroup(*group_id))
        group.packages.append(package)

    groups = sorted(groups.values())
    for group in groups:
        group.packages = sorted(group.packages, reverse=True)
        group.load_info()
    return groups


def get_data(remotes_file, packages_file):
    remotes = get_remotes(remotes_file)
    packages = get_packages(packages_file, remotes)

    for package in packages:
        remotes[package.remote.name].packages.append(package)

    for remote in remotes.values():
        remote.packages = sorted(remote.packages)

    remotes = [
        remote for remote in sorted(remotes.values()) if remote.packages
    ]
    package_groups = group_packages(packages)
    return dict(remotes=remotes, package_groups=package_groups)


def main():
    with open("packages.json", "r") as packages:
        with open(Path.home() / ".conan" / "remotes.json", "r") as remotes:
            data = get_data(remotes, packages)
    context = Context(sys.stdout, data=data)
    template = Template(filename="index.mako", output_encoding="utf-8")
    template.render_context(context)


if __name__ == "__main__":
    main()
