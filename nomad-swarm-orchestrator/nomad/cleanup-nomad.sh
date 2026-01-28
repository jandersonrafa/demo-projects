#!/bin/bash

# Script para remover o job do Nomad

echo "Removendo job java-mvc-vt do Nomad..."

# Remover o job
nomad job stop java-mvc-vt

# Limpar allocations
echo "Limpando allocations..."
nomad system gc

echo "Job java-mvc-vt removido com sucesso!"
