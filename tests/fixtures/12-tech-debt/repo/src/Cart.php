<?php
// TODO: remover depois da migração
function total($items) {
  // FIXME: arredondamento errado para centavos
  // HACK: compatibilidade com API v1
  return array_sum($items);
}
