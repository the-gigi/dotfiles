# dotfiles

This repository contains Gigi's dotfiles and other shell-y stuff.
The foundation is BASH on MacOS. There's no attempt to make it universal.
The README file introduces the general approach for organizing this stuff
and then explains how to install it, how to use the existing functionality
and how to extend it.

## Introduction

The goal is to have a zero to hero one-click setup that can be extended for specific purposes 
(e.g. work stuff) without 



## Installation

Make sure git is installed:

```
$ git version
git version 2.25.0
```



```
mkdir ~/git
cd ~/git
git clone https://github.com/the-gigi/dotfiles.git
cd dotfiles
. ./setup.sh
```

## Usage

The built-in functionality includes:

- Installing various tools
- Symlinking various rc files to the home dir
- Adding various tools and directories to the PATH
- Various functions
- Various aliases

You should check out the various files in the components.d directory. 


## Components


### SSH

### Git

### Docker

### Kubernetes

### MacOS

### Prompt

### iTerm2

## Extensions and customizations

Customization is done by running commands before and after the main bashrc script, as well as dropping files
in various directories that will be picked up and executed (sourced) by the main bash script.

To maintain order (in case it's important) files may have a double digit numeric prefix starting at 10 and they are  
so it's possible to add files in a certain execution order.