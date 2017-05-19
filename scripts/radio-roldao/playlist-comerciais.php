#!/usr/bin/php -q
<?php
/**
 * playlist.php: Gera playlists para o XMMS baseado em filtros PHP e MySQL
 * Carlos Daniel de Mattos Mercer <daniel@useinet.com.br>
 * 2004-02-18
*/
include "config.inc.php";	// Captura a rede e a loja

mysql_connect("localhost", "root", "");	// host, usuario, senha e DB
mysql_select_db("radio");

$interprete = "ZZZ";	// Interprete inicial

mysql_query("DELETE FROM playlists");	// limpa a playlist

// Zera os arquivos
mysql_query("UPDATE arquivos SET tocou='Nao' WHERE tocou='Sim'");

// Seleciona uma programacao valida para o dia de hoje
$programacoes = mysql_query("SELECT esquema,hora_inicio,hora_fim FROM
						   programacoes WHERE rede='$rede' AND
						   loja='$loja' AND CURDATE() >= data_inicio
						   AND CURDATE() <= data_fim AND
						   FIND_IN_SET(DAYOFWEEK(CURDATE()),dia_semana)
						   ORDER BY hora_inicio") or die('Erro: ' . mysql_error());

echo "/var/www/mudo.wav\n"; // adiciona arquivo mudo no inicio da playlist pra contornar o bug do mplayer

$intervalo = 0;

$comerciais = array();

// Percorre todas as programacoes validas para o dia de hoje
while ($programacao = mysql_fetch_object($programacoes)) {

	if (isset($arquivo_fim)) {
		$arquivo_inicio = $arquivo_fim;	// concatena programacoes
	} else {
		$arquivo_inicio = $programacao->hora_inicio;	// primeira
	}													// programacao

	// calcula o intervalo e desconta o atraso
	$intervalo += $programacao->hora_fim - $programacao->hora_inicio;
						 
	// Preenche o intervalo, baseado no esquema
	while ($intervalo > 0) {
		// Consulta tipo e genero na sequencia da grade
		$grades = mysql_query("SELECT tipo,genero from grades WHERE
							  esquema='$programacao->esquema' ORDER
							  BY sequencia");
		$ultimoTipo = "";
		$ultimoComercial = 0;
		$comercialTemp = new StdClass();
		// Repete a sequencia ate preencher o intervalo
		while ($grade = mysql_fetch_object($grades)) {
				
			if ($intervalo <= 0) { // Intervalo preenchido?
				break;
			}
			
			// Seleciona arquivo valido para o dia e para o horario
			$arquivos = mysql_query("SELECT tipo,genero,arquivo,tempo FROM
			arquivos WHERE rede='$rede' AND loja='$loja' AND
			tipo='$grade->tipo' AND genero='$grade->genero'
			AND CURDATE() >= data_inicio AND CURDATE() <= data_fim AND
			FIND_IN_SET(DAYOFWEEK(CURDATE()),dia_semana) AND
			'$arquivo_inicio' >= hora_inicio AND
			'$arquivo_fim' <= hora_fim AND tocou='Nao'");
			
			// Zera o genero e seleciona arquivo valido para o dia e para o horario
			if (mysql_num_rows($arquivos) == 0) {
				mysql_query("UPDATE arquivos SET tocou='Nao' WHERE
				rede='$rede' AND loja='$loja' AND tipo='$grade->tipo'
				AND genero='$grade->genero'");
				
				$arquivos = mysql_query("SELECT tipo,genero,arquivo,tempo FROM
				arquivos WHERE rede='$rede' AND loja='$loja' AND
				tipo='$grade->tipo' AND genero='$grade->genero'
				AND CURDATE() >= data_inicio AND CURDATE() <= data_fim AND
				FIND_IN_SET(DAYOFWEEK(CURDATE()),dia_semana) AND
				'$arquivo_inicio' >= hora_inicio AND
				'$arquivo_fim' <= hora_fim AND tocou='Nao'");
			}
			
			$num_rows = mysql_num_rows($arquivos) - 1; // Quantos arquivos?
			if ($num_rows < 0) { // trata resultado negativo 
				continue;
			}
			$rand = mt_rand(0, $num_rows); // Aleatorio com reposicao
			if (!@mysql_data_seek($arquivos, $rand)) { // Nao existe? 
				continue;
			}			

			$segundos = $arquivo_inicio % 60;
				$minutos = floor($arquivo_inicio / 60) % 60;
				$hora = floor($arquivo_inicio / 3600);

			$arquivo = mysql_fetch_object($arquivos);	// Seleciona um arquivo
			if ($arquivo->tipo == "comercial") {
				mysql_query("UPDATE arquivos SET tocou='Sim' WHERE arquivo='$arquivo->arquivo'");	// Queima o arquivo

				if($ultimoTipo == "comercial"){
					$comerciais[$ultimoComercial]->arquivo[] = "/usr/local/radio/generos/".$arquivo->tipo."/".$arquivo->genero."/".$arquivo->arquivo;
					$comerciais[$ultimoComercial]->tempo = $comerciais[$ultimoComercial]->tempo + $arquivo->tempo;
				}
				else{
					$c = new StdClass();
					$c->arquivo[] = "/usr/local/radio/generos/".$arquivo->tipo."/".$arquivo->genero."/".$arquivo->arquivo;
					$c->tempo = $arquivo->tempo;
					$c->inicio = $hora.':'.$minutos.':'.$segundos;

					$ultimoComercial = $arquivo_inicio;

					$comerciais[$arquivo_inicio] = $c;
				}
				//echo $hora.':'.$minutos.':'.$segundos.' | '."/usr/local/radio/generos/$arquivo->tipo/$arquivo->genero/$arquivo->arquivo\n"."<br />"; // Gera a playlist
			}

			$ultimoTipo = $arquivo->tipo;

			//echo $hora.':'.$minutos.':'.$segundos.' | '."/usr/local/radio/generos/$arquivo->tipo/$arquivo->genero/$arquivo->arquivo\n"."<br />"; // Gera a playlist

			// Calcula que horas o arquivo vai acabar
			$arquivo_fim = $arquivo_inicio + $arquivo->tempo;

			// Insere na tabela o playlist com os horarios
			mysql_query("INSERT INTO playlists (tipo, genero, arquivo,
					hora_inicio, hora_fim) VALUES ('$arquivo->tipo',
					'$arquivo->genero','$arquivo->arquivo','$arquivo_inicio',
					'$arquivo_fim')");

			$arquivo_inicio = $arquivo_fim; // Concatena arquivos

			$intervalo -= $arquivo->tempo; // Diminui o intervalo
		}
	}
}

/*
echo "<pre>";
print_r($comerciais);
echo "</pre>";
echo count($comerciais);
*/

// Libera variaveis e desconecta do banco
mysql_free_result($programacoes);
mysql_free_result($grades);
mysql_free_result($arquivos);
mysql_close();
?>
