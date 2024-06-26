# Large Scale Data Processing: Project 2

Authors:
- Ilan Valencius (valencig)
- Steven Roche (sroche14)
- Jason Adhinarta (jasonkena)

## Command
```sh
spark-submit \
  --class "project_2.main" \
  --master "local[*]" target/scala-2.12/project_2_2.12-1.0.jar 2014to2017.csv _inputs_
```

## Exact F0
__Inputs__: `exactF0`

_Running Locally_

`Exact F0. Time elapsed:15s. Estimate: 7406649`

_Running on GCP_
`Exact F0. Time elapsed:45s. Estimate: 7406649`

## Exact F2
__Inputs__: `exactF2`

_Running Locally_

`Exact F2. Time elapsed:16s. Estimate: 8567966130`

_Running on GCP_

`Exact F2. Time elapsed:55s. Estimate: 8567966130
`

## Tug-of-War (F2)
__Inputs__: `ToW 10 3`

_Running Locally_

`Tug-of-War F2 Approximation. Width :10. Depth: 3. Time elapsed:13s. Estimate: 6764401820`

_Running on GCP_
`Tug-of-War F2 Approximation. Width :10. Depth: 3. Time elapsed:121s. Estimate: 10913921792`

## BJKST (F0)
__Determination of maximum bucket size__

The maximum bucket size $|B|$ is determined by a constant $c$ and parameter $\varepsilon$ according to $|B| = \frac{c}{\varepsilon^2}$ and outputs a $(\varepsilon, \frac{1}{3})$ estimate. We are attempting to find a $\pm$ 20% estimate so $\varepsilon=0.2$. To determine $c$ we use the relation $$\mathbb{P}(\text{Failure}) \leq \frac{1}{12} +\frac{48}{c}$$ which is derived by using Chebyshev's inequality and Markov's inequality ([Chkrabarti Notes](https://www.cs.dartmouth.edu/~ac/Teach/data-streams-lecnotes.pdf), pg. 19.). For a $(\varepsilon, \frac{1}{3})$ estimate this probability must be upper bounded by $\frac{1}{6}$, therefore $$\mathbb{P}(\text{Failure}) \leq \frac{1}{12} +\frac{48}{c} \leq \frac{1}{6}$$ Solving this numerically yields a result of $c \geq 576$. Plugging into $\frac{c}{\varepsilon^2}$ yields $\boxed{14,400}$ for the minimum bucket width.

__Inputs__: `BJKST 14400 5`

_Running Locally_

`BJKST Algorithm. Bucket Size:14400. Trials:5. Time elapsed:5s. Estimate: 7921664.0`

_Running on GCP_

`BJKST Algorithm. Bucket Size:14400. Trials:5. Time elapsed:39s. Estimate: 7870464.0`

## Comparison of algorithms
We will first discuss the accuracy of the estimates by taking the values from running each function locally. 
| | True value | Estimated | Error of estimation ($\pm$%) |
| :-: | :-: | :-: | :-: |
| F0 | 7406649 | 7921664 | 6.5  |
| F2 | 8567966130 | 6764401820 | 21 |

From the analysis of the median-of-means approach for the Tug-of-War algorithm we know the number of trials for each mean is calculated according to $$k=\frac{6}{\varepsilon^2}$$ By manually setting the number of trials to be $k=10$ we are outputting a $\varepsilon \approx 0.77$ estimate (which is not good). Similarly the probability of getting an $(\varepsilon, \delta)$ estimate is bounded by $$t = 10 \log{\frac{1}{\delta}}$$ Again by manually setting $t=3$ we are outputting a $\varepsilon \approx 0.77$ estimate with probability $1-\delta \approx 0.26$. We find an estimate of $F_2$ that only deviates by $\varepsilon = 0.21$ so we can be confident that our algorithm works.

For the BJKST algorithm we have already discussed how we can ensure a $\varepsilon = 0.2$ estimate. We take $t=5$ so by the same approach we estimate a $\varepsilon =0.2$ estimate with probability $1-\delta \approx 0.394$. Given that our estimate only deviated by 6.5% we can be confident our algorithm works.

### Speedup Comparisions
In each of the algorithms, the run time for GCP is significantly longer than the runtime on the local machine. However, this is for several reasons. First, GCP takes some time to allocate resources to each job which adds to the runtime of GCP instead of on a local machine (where the resources are allocated very quickly). Moreover, the plate dataset is not of sufficient size to cause the local runtime to be longer than the GCP runtime. This is because GCP has an advantage over using a laptop only when the dataset is large enough to see significant benefits from the increased parallelization and computing power on GCP.
