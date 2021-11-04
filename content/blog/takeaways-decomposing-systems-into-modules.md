+++
title = "Takeaways: Decomposing Systems into Modules "
description = ""
date = 2021-11-30
slug = "takeaways-decompose-systems-into-modules"
draft = true
[extra]
references = "content/blog/takeaways-decomposing-systems-into-modules.bibtex"
+++

There's a lot of discussion on why and how we should modularize our systems.
Some provoke heated debates, often driven by personal preferences and subjective
judgments about the right way of writing software. These, in many cases, are
presented as an objective truth about what is good software architecture.

Often, these disagreements happen because the participants have failed to
establish a common ground on what the process of modularization should do.
Should simplify the code, improve the comprehensibility of the system, increase
flexibility, speed development process, what? Sometimes the contenders engage in
philosophical disputes about how much the things should be put together or
separated. They are the same thing, they are related things, or they are
separate things? Frequently, people have different opinions on that. Some people
like to spread code across as many files as possible. Others tend to pile the
code into a single file with thousands of lines of code. It's quite maddening.

Hopefully, some bright people wrote good advice on the matter. The seminal
article [On the Criteria To Be Used in Decomposing Systems into
Modules](https://doi.org/10.1145/361598.361623) from 1972, written by [David
Lorge Parnas](https://en.wikipedia.org/wiki/David_Parnas), is a must-read and
pretty enlightening.

### Modular programming benefits

Accordingly to Parnas, these are the three expected benefits of modular
programming:

{% reference(citationKey="Parnas1972") %}
(1) managerial - development time should be shortened because separate groups would work on each module with little need for communication: (2) product flexibility - it should be possible to make drastic changes to one module without a need to change others; (3) comprehensibility - it should be possible to study the system one module at a time. The whole system can therefore be better designed because it is better understood.
{% end %}

### Keyword In Context (KWIC)

[input and output](https://users.cs.duke.edu/~ola/ipc/kwic.html)

### Two decomposition examples

### Information hiding

### References
