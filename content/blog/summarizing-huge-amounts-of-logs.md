+++
title = "Summarizing huge amounts of logs"
date = 2021-11-01
draft = false
+++

Here at [americanas s.a.](https://www.americanas.com.br/) we've been getting
ready for the biggest e-commerce event of the year: [Black
Friday](https://en.wikipedia.org/wiki/Black_Friday_(shopping)). For the last two
months or so, we've been testing the resilience and scalability of ours
microservices. Usually, tests happen once a week, from one day to the other, and
it takes about 2 hours to finish.

As a member of the catalog team, we are responsible for several applications,
including a Graphql server in Golang that service over 3.5M requests per minute
in days with very high traffic. Our main task on these workload tests is to
check the application's metrics to spot, report, and resolve performance issues.
We also store data for posterior analysis, like throughput, response time
distributions, Kubernetes CPU usages, etc. For the most part, we have good
instrumentation to gather all the business and technical information that is
critical to us.

### Missing metrics

Nevertheless, a problem has arisen at the beginning of our last test. Our
application - let's call it `moonapi` - received an additional 1M requests per
minute compared to the previous test. That was strange because the workload
settings remained the same as last time. We started to investigate the problem
and sought clues in ours telemetry tools to find the reason for this increase.

My manager had a hunch. The increase in the throughput had occurred because the
frontend had requested new content from the ` moonapi`. To test his hypotheses,
we have to find a way to check what positions the frontend was calling. Just to
put it in context, this is how the `moonapi` works:

```txt
Schema:
/moonapi/:route/:platform/:position/:brand/:sitepage

Resource:    Possible Values:
:route       position|positions|curaded-list
:platform    mobile|desktop|app
:position    contenttop1|page-config|...
:brand       americanas|submarino|soubarato|shoptime
:sitepage    produto/moda/calcados

Example:
curl https://moonapi/publication/desktop/page-config/americanas/produto/moda
```

Unfortunately, the telemetry tool hadn't been instrumented at that time to
collect data about the platforms or positions most accessed. This data was not
accessible from either Datadog or Kibana dashboards. We'd to find another way of
getting this information. Luckily, we had the logs from the API requests flowing
in our pod's instances at AWS EC2. And I could easily access them via `kubectl`
command. My first idea was to pipe these logs into a file:

```sh
# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs
kubectl logs -n moon-namespace \
    -l app=moonapi \
    --max-log-requests 230 -f > moon_logs
```

After just one minute, I collected 618Mb of logs from the `moonapi`. Then I ran
the `wc` command to count the entries: 2.5M. That was a lot!

```sh
wc -l moon_logs
 2487232 moon_logs
```

Here is an example of the kind of information that was available within the
logs. I removed some keys for security reasons:

```sh
head -n 1 moon_logs | jq

{
  "duration": 1,
  "level": "info",
  "msg": "OK",
  "path": "/moonapi/publication/desktop/produto-descricao/americanas/produto/automotivo/autopecas/motor",
  "status": 200,
  "time": "2021-10-23T06:30:04Z"
}
```

I had a sample of one minute with 2.5M log entries. Each log entry had the
`path` that the frontend had requested. I just needed to do some data
manipulation to get the answer that we were looking for.

### Finding the path

I wanted to summarize the logs to get the ratio of requests made to each
position. To accomplish that, I needed to extract the *path* from the logs
first. With some try and error, this could be done using the `grep` and `sed`
commands. Let's extract the path from the logs:

```sh
bat moon_logs | sd '(.+"path":"|",.+)' '' -p > moon_paths
head -n 3 moon_paths

/moonapi/publication/desktop/produto-descricao/americanas/produto/automotivo/autopecas/motor
/moonapi/publications/app/americanas/search
/moonapi/publication/desktop/page-config/americanas/produto/esporte-e-lazer/bicicletas/componentes-e-pecas-para-bicicletas/camaras
```

Now I had to filter out the entries that are not made to the route
*publication*:

```sh
rg 'publication/' moon_paths > moon_publication_paths
head -n 3 moon_publication_paths

/moonapi/publication/desktop/produto-descricao/americanas/produto/automotivo/autopecas/motor
/moonapi/publication/desktop/page-config/americanas/produto/esporte-e-lazer/bicicletas/componentes-e-pecas-para-bicicletas/camaras
/moonapi/publication/desktop/blackbox/americanas/produto/
```
