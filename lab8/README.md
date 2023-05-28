## Overview

This doc presents pricing breakdown for all used services.

## General measurements

Let's assume that each requests takes about `512kb` of data. It gives us total `512MB` per thousand requests and `512GB` per million requests.

For simplicity, let's also assume that all volume of requests (1K or 1M) arrives distributed (not necessarily evenly) within one month.

All calculations are done using eu-central-1 (Frankfurt) region pricing.

## Producer part

### API Gateway (HTTP)

**1000 requests**: 1000 / 1_000_000 * 1.20$ = 0.0012$

**1M requests**: 1_000_000 / 1_000_000 * 1.20$ = 1.20$

### Lambda

This lambda is not a cpu-intense workload, so let's assume it uses `128mb of memory` for `100ms` per request. Data transfer to SQS is free because it occurs within the same region.

**1000 requests**: 1000 * 100 * 0.0000000021$ = 0.00021$

**1M requests**: 1_000_000 * 100 * 0.0000000021$ = 0.210$


## SQS part (Standart)

Each request triggers exactly 4 actions: write and read from both queues.

**1000 requests**: 1000 * 4 = potentially free in case it's the first 1 Million Requests/Month

**1M requests (actions)**: 1_000_000 * 4 / 1_000_000 * 0.40$ = 1.600$

**1M requests (data transfer)**: 512 * 2 * 0.09$ = 92.160$


## Consumer part

### Lambda

All measures are equal to `producer` part.

### S3 (Standart)

Further processing flow is unknown so we will only consider storing price.

**1000 requests**: 512MB / 1000 * 0.0245$ = 0.013$

**1M requests (data transfer)**: 512GB * 0.0245$ = 12.544$

### DynamoDB (On-Demand)

Let's assume each request uses 1 WRU.

**1000 requests (writing)**: 1000 / 1_000_000 * 1.525$ = 0.002$

**1000 requests (storage)**: 0.512 * 0.306$ = 0.306$

**1M requests (writing)**: 1_000_000 / 1_000_000 * 1.525$ = 1.525$

**1M requests (storage)**: 512 * 0.306$ = 156.672$

**1M requests (point-in-time-recovery)**: 512 * 0.2448$ = 125.337$

## Conclusion

In summary, two services (SQS and DynamoDB) use 90% of total expenses. The main driver for both of them is data storage and transfer cost. 

There are multiple potential ways to reduce costs sorted by feasibility.

1. Reduce individual request size. We assumed it to be `512KB` which is quite big for a usual web request.
2. Get rid of SQS. Same lambda can do all the processing and uploading.
3. Use "reference requests". Upload request body to S3 as early as possible and then use `requestId` to refer to it. 