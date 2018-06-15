#!/bin/sh

export BORG_REPO=/data/$(whoami)-s/$(hostname)

BORG="docker run --rm \
  -e BORG_PASSPHRASE \
  -e BORG_REPO \
  -e HOME \
  -u $(id -u) \
  -v $HOME:$HOME \
  -v /mnt/backup-drive:/data \
  borg borg"

set -xe

trap "echo $( date ) Backup interrupted >&2; exit 2" INT TERM

$BORG create                      \
  --verbose                       \
  --filter AME                    \
  --list                          \
  --stats                         \
  --show-rc                       \
  --compression lz4               \
  --exclude-caches                \
  ::'{hostname}-{now}'            \
  ${HOME}/Books                   \
  ${HOME}/Projects                \
  ${HOME}/Documents               \
  ${HOME}/Downloads               \
  ${HOME}/Public                  \

backup_exit=$?

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

$BORG prune              \
  --list                 \
  --prefix '{hostname}-' \
  --show-rc              \
  --keep-daily    7      \
  --keep-weekly   4      \
  --keep-monthly  6      \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
  echo "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
  echo "Backup and/or Prune finished with an error"
fi

exit ${global_exit}
