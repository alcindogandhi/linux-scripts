#!/bin/sh
#
# Cria um projeto mínimo em Java / Maven
#

helpFunction()
{
	echo ""
	echo "Script de criação de um projeto mínimo Java/Maven"
	echo ""
	echo "Uso: $(basename $0) [-h] [-g groupId] [-a artifactId] [-n name] [-p package] \
[-d description] [-v version] [-e sourceEncoding] [-j javaVersion] [-m mainApp]"
	echo "	-h: Mostra esta mensagem de ajuda."
	echo "	-g: Id do grupo do projeto. Ex.: $GROUP_ID"
	echo "	-a: Id do artefato do projeto. Ex.: $ARTIFACT_ID"
	echo "	-n: Nome do projeto. Ex.: $PRJ_NAME"
	echo "	-p: Pacote do projeto. Ex,: $PACKAGE"
	echo "	-d: Descrição do projeto. Ex.: $DESCRIPTTION"
	echo "	-v: Versão do projeto. Ex.: $VERSION"
	echo "	-e: Codificação dos arquivos do projeto. Ex.: $SOURCE_ENCODING"
	echo "	-j: Versão do Java do projeto. Ex.: $JAVA_VERSION"
	echo "	-m: Nome da classe principal da aplicação. Ex.: $MAIN_APP"
	echo
}

while getopts "hg:a:n:p:d:v:e:j:m:" opt
do
	case "$opt" in
		h ) helpFunction 
			exit 0 ;;
		g ) GROUP_ID="$OPTARG" ;;
		a ) ARTIFACT_ID="$OPTARG" ;;
		n ) PRJ_NAME="$OPTARG" ;;
		p ) PACKAGE="$OPTARG" ;;
		d ) DESCRIPTTION="$OPTARG" ;;
		v ) VERSION="$OPTARG" ;;
		e ) SOURCE_ENCODING="$OPTARG" ;;
		j ) JAVA_VERSION="$OPTARG" ;;
		m ) MAIN_APP="$OPTARG" ;;
		? ) helpFunction 
			exit 1 ;;		
   esac
done

if [ -z "$GROUP_ID" ]; then
	GROUP_ID="com.project"
fi
if [ -z "$ARTIFACT_ID" ]; then
	ARTIFACT_ID="minimal"
fi
if [ -z "$PRJ_NAME" ]; then
	PRJ_NAME="$ARTIFACT_ID"
fi
if [ -z "$PACKAGE" ]; then
	PACKAGE="$GROUP_ID.$ARTIFACT_ID"
fi
if [ -z "$DESCRIPTTION" ]; then
	DESCRIPTTION="Minimal Project"
fi
if [ -z "$VERSION" ]; then
	VERSION="0.0.1-SNAPSHOT"
fi
if [ -z "$SOURCE_ENCODING" ]; then
	SOURCE_ENCODING="UTF-8"
fi
if [ -z "$JAVA_VERSION" ]; then
	JAVA_VERSION="21"
fi
if [ -z "$MAIN_APP" ]; then
	MAIN_APP="MainApplication"
fi

PACKAGE_DIR=$(echo "src/main/java/$PACKAGE" | sed -e "s/\./\//g")
RESOURCE_DIR="src/main/resources"

echo
echo "Criação do projeto mínimo $PRJ_NAME"
echo
echo "GROUP_ID:        $GROUP_ID"
echo "ARTIFACT_ID:     $ARTIFACT_ID"
echo "PRJ_NAME:        $PRJ_NAME"
echo "PACKAGE:         $PACKAGE"
echo "PACKAGE_DIR:     $PACKAGE_DIR"
echo "RESOURCE_DIR:    $RESOURCE_DIR"
echo "DESCRIPTTION:    $DESCRIPTTION"
echo "VERSION:         $VERSION"
echo "SOURCE_ENCODING: $SOURCE_ENCODING"
echo "JAVA_VERSION:    $JAVA_VERSION"
echo "MAIN_APP:        $MAIN_APP"
echo

mkdir -p $PRJ_NAME
if [ $? -ne 0 ]; then
	echo "Erro! Falha na criação do diretório $PRJ_NAME."
	exit 2
fi

cd $PRJ_NAME
mkdir -p $PACKAGE_DIR
mkdir -p $RESOURCE_DIR

cat <<EOF >"pom.xml"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>$GROUP_ID</groupId>
	<artifactId>$ARTIFACT_ID</artifactId>
	<version>$VERSION</version>
	<name>$PRJ_NAME</name>
	<description>$DESCRIPTTION</description>
	<properties>
		<project.build.sourceEncoding>$SOURCE_ENCODING</project.build.sourceEncoding>
		<java.version>$JAVA_VERSION</java.version>
		<maven.plugin.version>3.12.1</maven.plugin.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<version>\${maven.plugin.version}</version>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>\${maven.plugin.version}</version>
				<configuration>
					<source>\${java.version}</source>
					<target>\${java.version}</target>
				</configuration>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-jar-plugin</artifactId>
				<version>3.4.1</version>
				<configuration>
				<archive>
					<manifest>
					<mainClass>$PACKAGE.$MAIN_APP</mainClass>
					</manifest>
				</archive>
				</configuration>
			</plugin>
		</plugins>
	</build>
</project>
EOF

echo "application.name=$PRJ_NAME" > 

cat <<EOF >"$RESOURCE_DIR/application.yaml"
app:
    name: $PRJ_NAME
EOF

cat <<EOF >"$PACKAGE_DIR/$MAIN_APP.java"
package $PACKAGE;

public class $MAIN_APP {

	public static void main(String[] args) {
		System.out.println("$DESCRIPTTION");
	}

}
EOF

echo
echo "Projeto $PRJ_NAME criado com sucesso"
echo
