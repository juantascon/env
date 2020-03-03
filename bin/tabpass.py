#! /usr/bin/env python3

import yaml
from plumbum.cmd import xdotool, gopass, rofi, echo

def get_browser_url():
  window_name = xdotool("getactivewindow", "getwindowname")
  window_name_parts = window_name.strip().split(" - ")
  browser = window_name_parts[-1]
  if browser in ["Mozilla Firefox", "Chromium", "Vivaldi"]:
    return window_name_parts[-2]
  else:
    return False

def get_secrets(url):
  all = gopass("ls", "--flat", "--strip-prefix", "web/").strip().split("\n")
  return ["web/{}".format(p) for p in all if url.endswith(p.split("@")[0])]

def get_obj(secret):
  parts = gopass("show", secret).split("\n---\n")
  obj = { "pass": parts[0] }
  extra = yaml.safe_load(parts[1]) if len(parts) == 2 else {}
  return {**obj, **extra} # merge

def ask(prompt, options):
  return (echo["\n".join(options)] | rofi["-dmenu", "-lines", len(options), "-hide-scrollbar", "-no-custom", "-p", prompt])().strip()

def paste(value):
  xdotool("type", "--clearmodifiers", "--", value)

def get_totp(secret):
  gopass("otp", "-o", secret).strip()

def main():
  url = get_browser_url()
  secrets = get_secrets(url)
  secret = ask("select secret:", secrets)
  obj = get_obj(secret)
  field = ask("select field:", list(obj.keys()))
  value = get_totp(secret) if field == "totp" else obj[field]
  paste(value)

if __name__== "__main__":
  main()
