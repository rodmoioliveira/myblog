+++
title = "One-Liners: Log Summarization"
description = "Here are some useful techniques for peeking, summarizing, and plotting logs data in the terminal."
date = 2021-10-27
slug = "one-liners-log-summarization"
draft = false
[extra]
references = "content/blog/one-liners-log-summarization.bibtex"
+++

We are going to use the
[web-server-access-logs](https://www.kaggle.com/eliasdabbas/web-server-access-logs)
dataset to demonstrate useful techniques of log summarization. To follow along,
you must have installed in your machine:
[awk](https://man7.org/linux/man-pages/man1/awk.1p.html),
[bat](https://github.com/sharkdp/bat),
[fd](https://github.com/sharkdp/fd),
[gnuplot](http://www.gnuplot.info/),
[head](https://man7.org/linux/man-pages/man1/head.1.html),
[rg](https://github.com/BurntSushi/ripgrep),
[sort](https://man7.org/linux/man-pages/man1/sort.1.html),
[tail](https://man7.org/linux/man-pages/man1/tail.1.html),
[uniq](https://man7.org/linux/man-pages/man1/uniq.1.html) and
[wc](https://man7.org/linux/man-pages/man1/wc.1.html) commands.

### Peeking

Let's begin by peeking at the data: how many logs do we have in the
[web-server-access-logs](https://www.kaggle.com/eliasdabbas/web-server-access-logs)
dataset? Use the `wc` command with the `-l` flag to count the total of lines in
the logs:

```sh
wc -l access.log

# 10365152 access.log
```

To get an idea of the logs structure, you can inspect the data with `head` and
`tail` commands:

```sh
head -n 3 access.log

# 54.36.149.41 - - [22/Jan/2019:03:56:14 +0330] "GET /filter/27|13%20%D9%85%DA%AF%D8%A7%D9%BE%DB%8C%DA%A9%D8%B3%D9%84,27|%DA%A9%D9%85%D8%AA%D8%B1%20%D8%A7%D8%B2%205%20%D9%85%DA%AF%D8%A7%D9%BE%DB%8C%DA%A9%D8%B3%D9%84,p53 HTTP/1.1" 200 30577 "-" "Mozilla/5.0 (compatible; AhrefsBot/6.1; +http://ahrefs.com/robot/)" "-"
# 31.56.96.51 - - [22/Jan/2019:03:56:16 +0330] "GET /image/60844/productModel/200x200 HTTP/1.1" 200 5667 "https://www.zanbil.ir/m/filter/b113" "Mozilla/5.0 (Linux; Android 6.0; ALE-L21 Build/HuaweiALE-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36" "-"
# 31.56.96.51 - - [22/Jan/2019:03:56:16 +0330] "GET /image/61474/productModel/200x200 HTTP/1.1" 200 5379 "https://www.zanbil.ir/m/filter/b113" "Mozilla/5.0 (Linux; Android 6.0; ALE-L21 Build/HuaweiALE-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36" "-"

tail -n 3 access.log

# 5.213.7.50 - - [26/Jan/2019:20:29:13 +0330] "GET /m/product/18962/%D8%BA%D8%B0%D8%A7-%D8%B3%D8%A7%D8%B2-%D9%85%D9%88%D9%84%DB%8C%D9%86%DA%A9%D8%B3-%D9%85%D8%AF%D9%84-FP7367RT HTTP/1.1" 200 20959 "https://www.google.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1" "-"
# 109.125.169.52 - - [26/Jan/2019:20:29:13 +0330] "GET /image/%7B%7BbasketItem.id%7D%7D?type=productModel&wh=50x50 HTTP/1.1" 200 5 "https://www.zanbil.ir/" "Mozilla/5.0 (Windows NT 6.1; rv:64.0) Gecko/20100101 Firefox/64.0" "-"
# 37.129.59.160 - - [26/Jan/2019:20:29:13 +0330] "GET /basket/view HTTP/1.1" 200 17299 "https://www-zanbil-ir.cdn.ampproject.org/v/s/www.zanbil.ir/m/product/32148/%DA%AF%D9%88%D8%B4%DB%8C-%D8%AA%D9%84%D9%81%D9%86-%D8%A8%DB%8C-%D8%B3%DB%8C%D9%85-%D9%BE%D8%A7%D9%86%D8%A7%D8%B3%D9%88%D9%86%DB%8C%DA%A9-%D9%85%D8%AF%D9%84-Panasonic-Cordless-Telephone-KX-TGC412?amp_js_v=0.1&usqp=mq331AQECAEoAQ%3D%3D" "Mozilla/5.0 (Linux; Android 6.0.1; D6633 Build/23.5.A.1.291) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Mobile Safari/537.36" "-"
```

You might want to check out a subset of the data. Use `bat` with the `-r` flag
to inspect just the sample within the range:

```sh
bat access.log -r 12345:12346 -n

# 12345 54.37.16.239 - - [22/Jan/2019:04:45:28 +0330] "GET /image/50761/productModel/200x200 HTTP/1.1" 200 4740 "https://www.zanbil.ir/m/filter/p24083?page=1" "Mozilla/5.0 (Linux; Android 9; G8142 Build/47.2.A.4.41) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Mobile Safari/537.36" "-"
# 12346 23.101.169.3 - - [22/Jan/2019:04:45:29 +0330] "GET /image/12682/productTypeMenu HTTP/1.1" 200 11 "https://www.zanbil.ir/browse/air-conditioner-split/%DA%A9%D9%88%D9%84%D8%B1-%DA%AF%D8%A7%D8%B2%DB%8C" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0;  Trident/5.0)" "-"
```

You can, if you want, use the `rg` command to filter the logs by the entries
that use the POST method and pipe the result into a file:

```sh
rg POST access.log > post_access.log
wc -l post_access.log

# 139155 post_access.log
```

### Summarizing

Now is when the fun begins: summarizing the data. Let's use `sd` to extract the
HTTP methods most used in the first 100,000 entries:

```sh
bat access.log -r 1:100000 | \
   sd '(.+)(GET|HEAD|POST|PUT|DELETE|CONNECT|OPTIONS|TRACE|PATCH)(.+)' '$2' | \
   sort | \
   uniq -c | \
   sort -n

#     2 OPTIONS
#    11 PUT
#   577 POST
#   725 HEAD
# 98685 GET
```

We might want to know the distribution of HTTP status code responses within a
subset range of the data, for example, from 30,000 to 40,000:

```sh
bat access.log -r 30000:40000 | \
   sd '(.+)" (\d{3}) (\d.+) "(.+)' '$2' | \
   sort | \
   uniq -c | \
   sort -n

#    1 400
#   11 403
#   38 499
#   51 304
#  150 404
#  177 301
#  321 302
# 9252 200
```

How about the top 3 user-agents from a sample of 100,000 entries?

```sh
bat access.log -r 1:100000 | \
   sd '(.+)"(.+)" ("-"$)' '$2' | \
   sort | \
   uniq -c | \
   sort -n | \
   tail -n 3

# 7533 Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
# 7784 Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
# 9566 Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)
```

### Plotting

It's time to get fancy! Let's construct a
[histogram](https://www.mathsisfun.com/data/histograms.html) of the
[$body_bytes_sent](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/#setting-up-the-access-log)
values present in the dataset. Check out this reference in
[StackOverflow](https://stackoverflow.com/questions/39614454/creating-histograms-in-bash)
on how to do it using [awk](https://man7.org/linux/man-pages/man1/awk.1p.html).
Let's create an awk script named `hist`:

```awk,linenos
#!/usr/bin/awk -f

BEGIN{
    bin_width=20000;
}
{
    bin=int(($1-0.0001)/bin_width);

    if(bin in hist){
        hist[bin]+=1
    }else{
        hist[bin]=1
    }
}
END{
    for (h in hist)
      printf "%2.2f %i\n", (h*bin_width)/1000000, hist[h]
}
```

Then, we have to add the script to our pipeline. Don't forget to make the awk
script executable first with `chmod +x hist`. Here's the histogram in bins of
20,000 bytes of the first 1,000,000 entries:

```sh
bat access.log -r 1:1000000 | \
   sd '(.+)" (\d{3}) (\d{0,10}) (".+)' '$3' | \
   ./hist | \
   sort -n > histogram_first_1000000.dat
bat histogram_first_1000000.dat

# 0,00 837305
# 0,02 91277
# 0,04 34250
# 0,06 15385
# 0,08 10300
# 0,10 3666
# 0,12 645
# 0,14 470
# 0,16 274
# 0,18 4143
# 0,20 250
# 0,22 152
# 0,24 264
# 0,26 199
# 0,28 22
# 0,30 80
# 0,32 11
# 0,34 22
# 0,36 21
# 0,38 10
# 0,40 7
# 0,42 12
# 0,44 1
# 0,48 149
# 0,50 114
# 0,52 144
# 0,54 500
# 0,56 263
# 0,58 28
# 0,64 3
# 0,66 1
# 0,68 3
# 0,70 18
# 0,74 1
# 0,76 2
# 0,78 1
# 0,86 1
# 0,90 1
# 1,12 3
# 1,14 1
# 1,24 1
```

To visualize the histogram, we could plot it with
[gnuplot](http://www.gnuplot.info/) directly in the terminal. Here's an example
for the first 1,000 entries:

```sh
bat access.log -r 1:1000 | \
   sd '(.+)" (\d{3}) (\d{0,10}) (".+)' '$3' | \
   ./hist | \
   sort -n > histogram_first_1000.dat

bat histogram_first_1000.dat | \
 gnuplot -p -e "set key off; \
 set style data histogram; \
 set term dumb 70 16; \
 plot '-' using 2:xtic(1)"

#  600 +-----------------------------------------------------------+
#      |     *+*    +      +      +     +      +      +     +      |
#  500 |-+   * *                                                 +-|
#      |     * *                                                   |
#  400 |-+   * *                                                 +-|
#      |     * *                                                   |
#  300 |-+   * *                                                 +-|
#      |     * *   ***                                             |
#  200 |-+   * *   * *                                           +-|
#      |     * *   * *    ***                                      |
#  100 |-+   * *   * *    * *                                    +-|
#      |     *+*   *+*    *+*     +     +      +      +     +      |
#    0 +-----------------------------------------------------------+
#           0,00  0,02   0,04   0,06  0,08   0,10   0,16  0,18
```

Cool huh?

### References
