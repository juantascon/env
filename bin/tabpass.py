#! /usr/bin/env python3

import yaml
import itertools
import urllib
from plumbum.cmd import bt, xdotool, gopass, rofi, echo


def get_browser_url():
  url = bt("query", "+active").split()[-1]
  print(url)
  netloc = urllib.parse.urlparse(url).netloc
  hostname = netloc.split(":")[0]
  return hostname

def list_secrets(url):
  all = gopass("ls", "--flat", "--strip-prefix", "web").strip().split("\n")
  if url:
    return ["web/{}".format(p) for p in all if url.endswith(p.split("@")[0])]
  else:
    return []
    #return ["web/{}".format(p) for p in all]

def list_options(secret):
  parts = gopass("show", secret).split("\n---\n")
  entries = [ {"key": "pass", "value": parts[0], "secret": secret} ]
  if len(parts) == 2:
    for key, value in (yaml.safe_load(parts[1])).items():
      entries.append({"key": key, "value": value, "secret": secret})
  return entries

def get_label(option):
  if option["key"] == "pass":
    sep = "-->"
  else:
    sep = "   "
  #TODO use on python 3.9: option["secret"].removeprefix("web/")
  return " {sep} {secret} . {key}".format(sep=sep, secret=option["secret"][len("web/"):], key=option["key"])

def ask(options):
  labels = [get_label(option) for option in options]
  response = (echo["\n".join(labels)] | rofi["-dmenu", "-matching", "fuzzy", "-format", "i", "-no-custom", "-p", "select:"])()
  index = int(response.strip())
  return options[index]

def paste(value):
  xdotool("type", "--clearmodifiers", "--", value)

def get_totp(secret):
  return gopass("otp", "-o", secret).strip()

def main():
  url = get_browser_url()
  print(url)
  secrets = list_secrets(url)
  options_matrix = [list_options(secret) for secret in secrets]
  options = list(itertools.chain.from_iterable(options_matrix))
  option = ask(options)
  value = get_totp(option["secret"]) if option["key"] == "totp" else option["value"]
  paste(value)

if __name__== "__main__":
  main()
