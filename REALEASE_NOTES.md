

* Execute this :

```bash
export OPS_HOME=$(pwd)/jblanswerabout
export DESIRED_VERSION=0.0.1
git clone https://github.com/Jean-Baptiste-Lasselle/mitesh-dialog ${OPS_HOME}
cd ${OPS_HOME}
git checkout ${DESIRED_VERSION}

cd mitesh
cat README.md | head -n 1

docker-compose config |grep image:
echo ""
echo "So you used portus image [opensuse/portus:head]"

```

* So you used the docker image `opensuse/portus:head` :  which does not exists on any public docker registry
* For a good reason : that is the dovelopement setup.
* And now I know you docker built yourself the image of `portus`: another thing that I miss
* Ok, those files having txt extension do not give me any kind of information I can work on.


I now do not need any more work to tell you :

* That you are not able to understand what reproduceability is,
* So I will definitely advise to forget working with `Portus`,
* And when you think you understand this explanation, and reproduceability
* You can try again and publicly ask a questionh to an engineer.

The good news, is now you can have a nice restful week-end.


JB.
