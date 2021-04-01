# npm6/7 install in docker test

This is a runnable benchmark which demonstrates that npm@7 has some kind of regression compared to npm@6 which makes it run very slow in docker bind mounts. This is a very common situation for CI/CD systems.

If you have docker installed, just clone this repo, `cd` into it and run 

```
./run.sh
```

It will take a few minutes.

The test will

1. Spin up a docker image of node 14, which comes with npm 6.14.11 at the time of writing (this step may take a while if you don't have the `node:14` image cached locally.)
2. Mount a volume containing a small but realistic `package.json`.
3. Run `npm install` three times in that mounted volume and print out the times (cleaning out before each run).
4. Copy the `package.json` to a "local" folder (not a bind mount) and run `npm install` three times in that folder too.
5. Upgrade to npm@latest (7.7.4 at the time of writing)
6. Repeat (3) and (4) 


## Findings

I would expect npm@7 to be as quick as, or quicker than npm@6. Running locally, with no virtualization, it runs in any where from 50-100% of the running time of npm@6.

In this test (and in our CI environment), it is in fact roughly 3 times slower than npm@6.


## Sample output

This is what I get when I run this benchmark. The first 6 results are all npm@6 and they all run in roughly the same time (the very first one is slightly slower because it's warming up the cache.)

The last six results show a dramatic split between the `/mounted` path and the `/local` path. On `/local` the times are comparable to npm@6. On `/mounted`, the times are almost exactly 3 times higher.

```
/mounted, npm 6.14.11, run 1...  
17.141                           
/mounted, npm 6.14.11, run 2...  
12.854                           
/mounted, npm 6.14.11, run 3...  
13.010                           
/local, npm 6.14.11, run 1...    
12.537                           
/local, npm 6.14.11, run 2...    
12.545                           
/local, npm 6.14.11, run 3...    
12.541                           
UPGRADING TO NPM 7... 6.807      
/mounted, npm 7.7.6, run 1...    
37.973                           
/mounted, npm 7.7.6, run 2...    
37.719                           
/mounted, npm 7.7.6, run 3...    
37.162                           
/local, npm 7.7.6, run 1...      
13.861                           
/local, npm 7.7.6, run 2...      
12.167                           
/local, npm 7.7.6, run 3...      
13.736                           
```


