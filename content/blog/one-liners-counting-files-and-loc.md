+++
title = "One-Liners: Counting Files and LOC"
date = 2021-10-25
draft = false
+++

Sometimes is useful to count the number of files and/or LOC a project has.
Here's a way you could do that using [fd](https://github.com/sharkdp/fd),
[xargs](https://man7.org/linux/man-pages/man1/xargs.1.html),
[wc](https://man7.org/linux/man-pages/man1/wc.1.html) and
[sort](https://man7.org/linux/man-pages/man1/sort.1.html):

```sh
# count the total LOC with files in crescent order by LOC.
fd . -t f | xargs wc -l | sort -n

# count the total LOC of scss files in crescent order by LOC.
fd . -e scss | xargs wc -l | sort -n

# count the number of files a project has.
fd . -t f | wc -l
```
