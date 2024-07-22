# npm6/7 install in docker test

ARCHIVED: This test is no longer relevant. The regression was fixed in npm@8, 9, or 10.

This is a runnable benchmark which demonstrates that npm@7 had some kind of regression compared to npm@6 which made it run very slow in docker bind mounts. This is a very common situation for CI/CD systems.

Issue: https://github.com/npm/cli/issues/2011#

If you have docker installed, just clone this repo, `cd` into it and run

```
./run.sh
```

It will take a few minutes.

The test will

1. Spin up a docker image of node 18, which comes with npm 6.14.11 at the time of writing (this step may take a while if you don't have the `node:14` image cached locally.)
2. Mount a volume containing a small but realistic `package.json`.
3. Install npm@6
4. Run `npm install` three times in that mounted volume and print out the times (cleaning out before each run).
5. Copy the `package.json` to a "local" folder (not a bind mount) and run `npm install` three times in that folder too.
6. Upgrade to npm@latest (7.7.4 at the time of writing)
7. Repeat (3) and (4)
8. Upgrade to npm@10 (current latest at time of writing)
7. Repeat (3) and (4)
9. Then just for giggles, install pnpm@9 and repeat (3) and (4) just to make the point that pnpm is faster than even npm@10.

## Findings

I would expect npm@7 to be as quick as, or quicker than npm@6. Running locally, with no virtualization, it runs in any where from 50-100% of the running time of npm@6.

In this test (and in our CI environment), it is in fact roughly 3 times slower than npm@6.


## Sample output

This is what I get when I run this benchmark. The npm 6 results are fairly consistent and they all run in roughly the same time (the very first one is slightly slower because it's warming up the cache.)

The npm 7 results show a dramatic split between the `/mounted` path and the `/local` path. On `/local` the times are comparable to npm@6. On `/mounted`, the times are almost exactly 3 times higher.

Npm 10 results show that them regression was fixed somewhere in npm 8, 9, or 10.

Finally, the pnpm 9 results show that pnpm is just very fast.

```
INSTALLING NPM@6...
10.242

/mounted, npm 6.14.18, run 1...
19.890
/mounted, npm 6.14.18, run 2...
13.400
/mounted, npm 6.14.18, run 3...
12.692
/local, npm 6.14.18, run 1...
11.716
/local, npm 6.14.18, run 2...
11.422
/local, npm 6.14.18, run 3...
11.300

UPGRADING TO NPM@7...
8.788

/mounted, npm 7.24.2, run 1... npm notice npm notice New major version of npm available! 7.24.2 -> 10.8.2 npm notice Changelog: <https://github.com/npm/cli/releases/tag/v10.8.2> npm notice Run `npm install -g npm@10.8.2` to update! npm notice
36.902
/mounted, npm 7.24.2, run 2...
35.840
/mounted, npm 7.24.2, run 3...
35.442
/local, npm 7.24.2, run 1...
11.638
/local, npm 7.24.2, run 2...
9.282
/local, npm 7.24.2, run 3...
10.208

UPGRADING TO NPM@10...
2.395

/mounted, npm 10.8.2, run 1...
26.583
/mounted, npm 10.8.2, run 2...
11.067
/mounted, npm 10.8.2, run 3...
10.832
/local, npm 10.8.2, run 1...
10.098
/local, npm 10.8.2, run 2...
10.273
/local, npm 10.8.2, run 3...
10.513

INSTALLING PNPM@9...
1.287

/mounted, pnpm 9.6.0, run 1...
5.289
/mounted, pnpm 9.6.0, run 2...
5.420
/mounted, pnpm 9.6.0, run 3...
5.219
/local, pnpm 9.6.0, run 1...
5.333
/local, pnpm 9.6.0, run 2...
5.952
/local, pnpm 9.6.0, run 3...
6.034
```


