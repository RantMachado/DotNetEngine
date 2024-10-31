#!/usr/bin/env sh

# Creating a motor to automize a creation of strutuct of folders in .net
#
# Author: Randolfo Machado Gama
# 
# Usage: bash run.sh name_app | OPTIONAL: dir_app | OPTIONAL: ROOT FOLDER
# Example 1: sh run.sh StoreAPI 
# Example 2: sh run.sh StoreAPI ../../dotnet
# Example 3: sh run.sh StoreAPI ../../dotnet src

name_app=$1
dir_app=$2
folder_root=$3

# 1º Creating folder

if [ -z "$name_app" ]; then
  echo "Project need a name!"
  exit
fi

if [ -z "$folder_root" ]; then
  folder_root="$name_app"
fi

if [ -z "$dir_app" ]; then
  dir_app='.'
  mkdir "$name_app"
else
  mkdir "$dir_app"/"$folder_root"
fi

# 3º Creating projects, classlib and webapi

dotnet new classlib -o "$dir_app"/"$folder_root"/"$name_app".Domain

dotnet new classlib -o "$dir_app"/"$folder_root"/"$name_app".Application

dotnet new classlib -o "$dir_app"/"$folder_root"/"$name_app".Infra.Data

dotnet new classlib -o "$dir_app"/"$folder_root"/"$name_app".Infra.IoC

dotnet new webapi --use-controllers -o "$dir_app"/"$folder_root"/"$name_app".WebApi

dotnet new xunit -o "$dir_app"/"$folder_root"/"$name_app".Tests

dotnet new sln --name $name_app -o "$dir_app"/"$folder_root" 

# 3º Creating dependencys between projects

dotnet add "$dir_app"/"$folder_root"/"$name_app".Application reference "$dir_app"/"$folder_root"/"$name_app".Domain/"$name_app".Domain.csproj

dotnet add "$dir_app"/"$folder_root"/"$name_app".Infra.Data reference "$dir_app"/"$folder_root"/"$name_app".Domain/"$name_app".Domain.csproj

dotnet add "$dir_app"/"$folder_root"/"$name_app".Infra.IoC reference "$dir_app"/"$folder_root"/"$name_app".Domain/"$name_app".Domain.csproj
dotnet add "$dir_app"/"$folder_root"/"$name_app".Infra.IoC reference "$dir_app"/"$folder_root"/"$name_app".Application/"$name_app".Application.csproj
dotnet add "$dir_app"/"$folder_root"/"$name_app".Infra.IoC reference "$dir_app"/"$folder_root"/"$name_app".Infra.Data/"$name_app".Infra.Data.csproj

dotnet add "$dir_app"/"$folder_root"/"$name_app".WebApi reference "$dir_app"/"$folder_root"/"$name_app".Infra.IoC/"$name_app".Infra.IoC.csproj

dotnet add "$dir_app"/"$folder_root"/"$name_app".Tests reference "$dir_app"/"$folder_root"/"$name_app".Domain/"$name_app".Domain.csproj
dotnet add "$dir_app"/"$folder_root"/"$name_app".Tests reference "$dir_app"/"$folder_root"/"$name_app".Application/"$name_app".Application.csproj

# 4º Add projects on solution

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".Domain/"$name_app".Domain.csproj

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".Application/"$name_app".Application.csproj

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".Infra.Data/"$name_app".Infra.Data.csproj

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".Infra.IoC/"$name_app".Infra.IoC.csproj

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".WebApi/"$name_app".WebApi.csproj

dotnet sln "$dir_app"/"$folder_root"/"$name_app".sln add "$dir_app"/"$folder_root"/"$name_app".Tests/"$name_app".Tests.csproj

# 5º clean and build project

dotnet clean "$dir_app"/"$folder_root"

dotnet build "$dir_app"/"$folder_root"

cd "$dir_app"/"$folder_root"

echo "The project "$name_app" make with success! This solution is "$name_app".sln and the root dir: "$dir_app"."