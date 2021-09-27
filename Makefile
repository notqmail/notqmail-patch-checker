GIT = https://github.com/notqmail/notqmail
REF = $$(git -C notqmail.git rev-parse ${BRANCH})
LOG = notqmail-${REF}-${PATCH}.log

all:v
	@test -n '${BRANCH}' -a -n '${PATCH}'
	@make log COMMIT=${REF} PATCH=${PATCH}

everything:v
	@xargs -I {} -n 1 make patches BRANCH={} <conf-branch

branches:v
	@echo '>>> building all $@ for patch ${PATCH}'
	@xargs -I {} -n 1 make BRANCH={} PATCH=${PATCH} <conf-branch

patches:v
	@echo '>>> building all $@ for branch ${BRANCH}'
	@ls patch | sed 's/.patch$$//' |\
	 xargs -I {} -n 1 make BRANCH=${BRANCH} PATCH={}

log:v \
notqmail-${COMMIT}-${PATCH}.log
notqmail-${COMMIT}-${PATCH}.log:
	-make build COMMIT=${COMMIT} PATCH=${PATCH} >$*.tmp 2>&1
	mv $*.tmp $@

build:v notqmail-${COMMIT}-${PATCH}
	make -C notqmail-${COMMIT}-${PATCH} it
	@echo success

notqmail-${COMMIT}-${PATCH}:v notqmail.git
	rm -rf $@
	git -C notqmail.git fetch origin ${COMMIT}
	git -C notqmail.git archive --prefix=$@/ ${COMMIT} | tar xf -
	cd $@; patch -p1 <../patch/${PATCH}.patch

notqmail.git:
	git clone --bare ${GIT} $@

README.md:v
	sh README.sh >$@

clean:v
	rm -rf notqmail-*/

v: # virtual target