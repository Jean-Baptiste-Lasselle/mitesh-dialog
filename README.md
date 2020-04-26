# My hot IDE


## Run it

* Inside an empty directory, execute :

```bash
export YOUR_GITLAB_TOKEN=G004GHH7llhy54

# --- #
# atom .
# --- #
git clone git@github.com:Jean-Baptiste-Lasselle/mitesh-dialog.git .
git chekout feature/preparing-first-release
echo "${YOUR_GITLAB_TOKEN}" > $(pwd)/secret-manager/${TOPSECRET_FILE_NAME}
./launch.sh
atom .
```

* now, you can edit you rcode in the current directory, and to commit and push :

```bash
# Then , to commit and push :
docker exec -it secretmanager bash -c "git config  commit.gpgsign false && git add --all && git commit -m 'ajout de la définition du conteneur hot_ide' && git push -u origin --all"
```
