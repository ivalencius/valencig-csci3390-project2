# Large Scale Data Processing: Project 2

Authors:
- Ilan Valencius (valencig)

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

## Exact F2
__Inputs__: `exactF2`

_Running Locally_

`Exact F2. Time elapsed:16s. Estimate: 8567966130`

_Running on GCP_

## Tug-of-War (F2)
__Inputs__: `ToW 10 3`

_Running Locally_

`ug-of-War F2 Approximation. Width :10. Depth: 3. Time elapsed:13s. Estimate: 6764401820`

_Running on GCP_

## BJKST (F0)
__Determination of maximum bucket size__

The maximum bucket size $|B|$ is determined by a constant $c$ and parameter $\varepsilon$ according to $|B| = \frac{c}{\varepsilon^2}$ and outputs a $(\varepsilon, \frac{1}{3})$ estimate. We are attempting to find a $\pm$ 20% estimate so $\varepsilon=0.2$. To determine $c$ we use the relation $$\mathbb{P}(\text{Failure}) \leq \frac{1}{12} +\frac{48}{c}$$ which is derived by using Chebyshev's inequality and Markov's inequality ([Chkrabarti Notes](https://www.cs.dartmouth.edu/~ac/Teach/data-streams-lecnotes.pdf), pg. 19.). For a $(\varepsilon, \frac{1}{3})$ estimate this probability must be upper bounded by $\frac{1}{6}$, therefore $$\mathbb{P}(\text{Failure}) \leq \frac{1}{12} +\frac{48}{c} \leq \frac{1}{6}$$ Solving this numerically yields a result of $c \geq 576$. Plugging into $\frac{c}{\varepsilon^2}$ yields $\boxed{14,400}$ for the maximum bucket with.

__Inputs__: `BJKST 14400 5`

_Running Locally_

`BJKST Algorithm. Bucket Size:14400. Trials:5. Time elapsed:5s. Estimate: 7921664.0`

_Running on GCP_

## Comparison of algorithms
We will first discuss the accuracy of the estimates by taking the values from running each function locally. 
| | True value | Estimated | Error of estimation ($\pm$%) |
| :-: | :-: | :-: | :-: |
| F0 | 7406649 | 7921664 | 6.5  |
| F2 | 8567966130 | 6764401820 | 21 |

From the analysis of the median-of-means approach for the Tug-of-War algorithm we know the number of trials for each mean is calculated according to $$k=\frac{6}{\varepsilon^2}$$ By manually setting the number of trials to be $k=10$ we are outputting a $\varepsilon \approx 0.77$ estimate (which is not good). Similarly the probability of getting an $(\varepsilon, \delta)$ estimate is bounded by $$t = 10 \log{\frac{1}{\delta}}$$ Again by manually setting $t=3$ we are outputting a $\varepsilon \approx 0.77$ estimate with probability $1-\delta \approx 0.26$. We find an estimate of $F_2$ that only deviates by $\varepsilon = 0.21$ so we can be confident that our algorithm works.

For the BJKST algorithm we have already discussed how we can ensure a $\varepsilon = 0.2$ estimate. We take $t=5$ so by the same approach we estimate a $\varepsilon =0.2$ estimate with probability $1-\delta \approx 0.394$. Given that our estimate only deviated by 6.5% we can be confident our algorithm works.

__NOW TALK ABOUT SPEEDUP__

## Calculating and reporting your findings
You'll be submitting a report along with your code that provides commentary on the tasks below.  

1. **(3 points)** Implement the `exact_F2` function. The function accepts an RDD of strings as an input. The output should be exactly `F2 = sum(Fs^2)`, where `Fs` is the number of occurrences of plate `s` and the sum is taken over all plates. This can be achieved in one line using the `map` and `reduceByKey` methods of the RDD class. Run `exact_F2` locally **and** on GCP with 1 driver and 4 machines having 2 x N1 cores. Copy the results to your report. Terminate the program if it runs for longer than 30 minutes.
2. **(3 points)** Implement the `Tug_of_War` function. The function accepts an RDD of strings, a parameter `width`, and a parameter `depth` as inputs. It should run `width * depth` Tug-of-War sketches, group the outcomes into groups of size `width`, compute the means of each group, and then return the median of the `depth` means in approximating F2. A 4-universal hash function class `four_universal_Radamacher_hash_function`, which generates a hash function from a 4-universal family, has been provided for you. The generated function `hash(s: String)` will hash a string to 1 or -1, each with a probability of 50%. Once you've implemented the function, set `width` to 10 and `depth` to 3. Run `Tug_of_War` locally **and** on GCP with 1 driver and 4 machines having 2 x N1 cores. Copy the results to your report. Terminate the program if it runs for longer than 30 minutes. **Please note** that the algorithm won't be significantly faster than `exact_F2` since the number of different cars is not large enough for the memory to become a bottleneck. Additionally, computing `width * depth` hash values of the license plate strings requires considerable overhead. That being said, executing with `width = 1` and `depth = 1` should generally still be faster.
3. **(3 points)** Implement the `BJKST` function. The function accepts an RDD of strings, a parameter `width`, and a parameter `trials` as inputs. `width` denotes the maximum bucket size of each sketch. The function should run `trials` sketches and return the median of the estimates of the sketches. A template of the `BJKSTSketch` class is also included in the sample code. You are welcome to finish its methods and apply that class or write your own class from scratch. A 2-universal hash function class `hash_function(numBuckets_in: Long)` has also been provided and will hash a string to an integer in the range `[0, numBuckets_in - 1]`. Once you've implemented the function, determine the smallest `width` required in order to achieve an error of +/- 20% on your estimate. Keeping `width` at that value, set `depth` to 5. Run `BJKST` locally **and** on GCP with 1 driver and 4 machines having 2 x N1 cores. Copy the results to your report. Terminate the program if it runs for longer than 30 minutes.
4. **(1 point)** Compare the BJKST algorithm to the exact F0 algorithm and the tug-of-war algorithm to the exact F2 algorithm. Summarize your findings.

## Submission via GitHub
Delete your project's current **README.md** file (the one you're reading right now) and include your report as a new **README.md** file in the project root directory. Have no fear—the README with the project description is always available for reading in the template repository you created your repository from. For more information on READMEs, feel free to visit [this page](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-readmes) in the GitHub Docs. You'll be writing in [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown). Be sure that your repository is up to date and you have pushed all changes you've made to the project's code. When you're ready to submit, simply provide the link to your repository in the Canvas assignment's submission.

## You must do the following to receive full credit:
1. Create your report in the ``README.md`` and push it to your repo.
2. In the report, you must include your (and your partner's) full name in addition to any collaborators.
3. Submit a link to your repo in the Canvas assignment.

## Late submission penalties
Please refer to the course policy.
