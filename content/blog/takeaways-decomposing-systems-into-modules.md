+++
title = "Takeaways: Decomposing Systems into Modules "
description = ""
date = 2021-11-30
slug = "takeaways-decompose-systems-into-modules"
draft = true
+++

There's a lot of discussions on why and how we should modularize ours systems.
Some provoke heated debates, often driven by personal preferences and subjective
judgments about the right way of writing software. These, in many cases, are
presented as an objective truth about what is good software architecture.

Often, these disagreements happen because the participants have failed to
establish a common ground on what the process of modularization should do.
Should simplify the code, improve the comprehensibility of the system, increase
flexibility, speed development process, what? Sometimes the contenders engage in
philosophical disputes about how much things should be put together or
separated. They are the same thing, they are related things, or they are
separated things? Frequently, people have different opinions on that. Some
people like to spread code across many files as possible. Others tend to pile
the code into a single file with thousands of lines of code. It's quite
maddening.

Hopefully, some bright people wrote good advice on the matter. The article [On
the Criteria To Be Used in Decomposing Systems into
Modules](http://citeseer.ist.psu.edu/viewdoc/summary?doi=10.1.1.132.7232) from
1972, written by [David Lorge
Parnas](https://en.wikipedia.org/wiki/David_Parnas), is a must-read and pretty
enlightening.
