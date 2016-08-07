Just to remind myself of my own release process for this repo.

1. Make some changes / merge PR
2. Bump version in `package.json`
3. Update `README.md` if needed
4. Update `CHANGELOG.md`
5. Webpack build

        webpack -p

6. Test it all works

        serve
        open index.html -a 'Google Chrome'

7. Tag and push the release

        git tag 1.0.x
        git push
        git push --tags

8. Publish on NPM

        npm publish

9. Update Githup Pages

        git checkout gh-pages
        git merge master
        git push

9. Cup of tea
