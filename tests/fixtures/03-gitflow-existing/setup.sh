# Executado dentro do repositório já com o commit inicial em main.
git tag v1.0.0
git checkout -q -b develop
echo "# a" > a.md && git add -A && git commit -q -m "feat(core): add a"
git checkout -q -b feature/ABC-1-login
echo "# b" > b.md && git add -A && git commit -q -m "feat(auth): login form"
git checkout -q develop && git merge -q --no-ff feature/ABC-1-login -m "Merge branch 'feature/ABC-1-login' into develop"
git checkout -q -b release/1.1
echo "# c" > c.md && git add -A && git commit -q -m "chore(release): 1.1.0"
git checkout -q main && git merge -q --no-ff release/1.1 -m "Merge branch 'release/1.1'"
git tag v1.1.0
git checkout -q -b hotfix/1.1.1
echo "# d" > d.md && git add -A && git commit -q -m "fix(auth): null session"
git checkout -q develop
