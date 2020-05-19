#! /usr/bin/env python3

import yaml
import itertools
from plumbum.cmd import xdotool, gopass, rofi, echo

def get_browser_url():
  window_name = xdotool("getactivewindow", "getwindowname")
  window_name_parts = window_name.strip().split(" - ")
  browser = window_name_parts[-1]
  if browser in ["Mozilla Firefox", "Mozilla Firefox (Private Browsing)", "Chromium", "Vivaldi"]:
    return window_name_parts[-2]
  else:
    return False

def list_secrets(url):
  all = gopass("ls", "--flat", "--strip-prefix", "web/").strip().split("\n")
  if url:
    return ["web/{}".format(p) for p in all if url.endswith(p.split("@")[0])]
  else:
    return ["web/{}".format(p) for p in all]

def list_options(secret):
  parts = gopass("show", secret).split("\n---\n")
  entries = [ {"key": "pass", "value": parts[0], "secret": secret} ]
  if len(parts) == 2:
    for key, value in (yaml.safe_load(parts[1])).items():
      entries.append({"key": key, "value": value, "secret": secret})
  return entries

def get_label(option):
  if option["key"] == "pass":
    return "--> " + option["secret"]
  else:
    return "    " + option["secret"] + " : " + option["key"]

def ask(options):
  labels = [get_label(option) for option in options]
  #response = (echo["\n".join(labels)] | rofi["-dmenu", "-lines", len(options), "-matching=fuzzy", "-format=i", "-hide-scrollbar", "-no-custom", "-p", "select:"])()
  response = (echo["\n".join(labels)] | rofi["-dmenu", "-matching", "fuzzy", "-format", "i", "-no-custom", "-p", "select:"])()
  index = int(response.strip())
  return options[index]

def paste(value):
  xdotool("type", "--clearmodifiers", "--", value)

def get_totp(secret):
  return gopass("otp", "-o", secret).strip()

def main():
  url = get_browser_url()
  secrets = list_secrets(url)
  options_matrix = [list_options(secret) for secret in secrets]
  options = list(itertools.chain.from_iterable(options_matrix))
  option = ask(options)
  value = get_totp(option["secret"]) if option["key"] == "totp" else option["value"]
  paste(value)

if __name__== "__main__":
  main()
