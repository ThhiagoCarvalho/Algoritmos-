algoritmo "UniLibrary"
// Desafio 1 - Logica de Programacao - Tema 4
// No VisuAlg 3.0.7, vetores de registros nao podem ser parametros.
// Acervo, indice, ranking e matriz sao o estado global do programa.

const
   MAX_LIVROS = 40
   MAX_CATEGORIAS = 5
   ANO_ATUAL = 2026
   TECNOLOGIA = 1
   EXATAS = 2
   HUMANAS = 3
   NEGOCIOS = 4
   LITERATURA = 5
   DISPONIVEL = 1
   INDISPONIVEL = 0
   EMPRESTIMO = 1
   DEVOLUCAO = 2
   NAO_ENCONTRADO = 0

tipo
   TLivro = registro
      codigo: inteiro
      titulo: caractere
      autor: caractere
      ano: inteiro
      categoria: inteiro
      qtdTotal: inteiro
      qtdDisponivel: inteiro
      qtdEmprestimos: inteiro
      status: inteiro
   fimregistro

var
   acervo: vetor[1..40] de TLivro
   ranking: vetor[1..40] de TLivro
   indiceCodigos: vetor[1..40] de inteiro
   indicePosicoes: vetor[1..40] de inteiro
   movimentacoes: vetor[1..5, 1..2] de inteiro
   totalLivros, opcao: inteiro

funcao ehInteiroPositivo(texto: caractere): logico
var
   i: inteiro
   digito: caractere
   valido: logico
inicio
   valido <- (compr(texto) > 0) e (compr(texto) <= 6)
   para i de 1 ate compr(texto) faca
      digito <- copia(texto, i, 1)
      se (digito < "0") ou (digito > "9") entao
         valido <- falso
      fimse
   fimpara
   retorne valido
fimfuncao

funcao lerInteiro(mensagem: caractere; minimo, maximo: inteiro): inteiro
var
   entrada: caractere
   numero: inteiro
   valido: logico
inicio
   repita
      escreva(mensagem)
      leia(entrada)
      valido <- ehInteiroPositivo(entrada)
      se valido entao
         numero <- caracpnum(entrada)
         valido <- (numero >= minimo) e (numero <= maximo)
      fimse
      se nao valido entao
         escreval("Entrada invalida. Informe inteiro entre ", minimo, " e ", maximo, ".")
      fimse
   ate valido
   retorne numero
fimfuncao

funcao nomeCategoria(categoria: inteiro): caractere
inicio
   escolha categoria
      caso TECNOLOGIA
         retorne "Tecnologia"
      caso EXATAS
         retorne "Ciencias Exatas"
      caso HUMANAS
         retorne "Ciencias Humanas"
      caso NEGOCIOS
         retorne "Administracao e Negocios"
      caso LITERATURA
         retorne "Literatura"
   fimescolha
   retorne "Categoria desconhecida"
fimfuncao

funcao localizarLivro(codigo, quantidade: inteiro): inteiro
var
   i, posicao: inteiro
inicio
   i <- 1
   posicao <- NAO_ENCONTRADO
   enquanto (i <= quantidade) e (posicao = NAO_ENCONTRADO) faca
      se acervo[i].codigo = codigo entao
         posicao <- i
      fimse
      i <- i + 1
   fimenquanto
   retorne posicao
fimfuncao

funcao qtdEmprestada(posicao: inteiro): inteiro
inicio
   retorne acervo[posicao].qtdTotal - acervo[posicao].qtdDisponivel
fimfuncao

procedimento mostrarLivro(posicao: inteiro)
inicio
   escreval("Codigo: ", acervo[posicao].codigo)
   escreval("Titulo: ", acervo[posicao].titulo)
   escreval("Autor: ", acervo[posicao].autor)
   escreval("Ano: ", acervo[posicao].ano)
   escreval("Categoria: ", acervo[posicao].categoria, " - ", nomeCategoria(acervo[posicao].categoria))
   escreval("Exemplares: ", acervo[posicao].qtdTotal, " | Disponiveis: ", acervo[posicao].qtdDisponivel)
   escreval("Emprestados agora: ", qtdEmprestada(posicao))
   escreval("Emprestimos acumulados: ", acervo[posicao].qtdEmprestimos)
   se acervo[posicao].status = DISPONIVEL entao
      escreval("Status: Disponivel")
   senao
      escreval("Status: Indisponivel")
   fimse
fimprocedimento

procedimento cadastrarLivro(var quantidade: inteiro)
var
   novo: TLivro
   codigo: inteiro
   valido: logico
inicio
   se quantidade >= MAX_LIVROS entao
      escreval("Capacidade maxima de ", MAX_LIVROS, " livros atingida.")
   senao
      repita
         codigo <- lerInteiro("Codigo (1 a 999999): ", 1, 999999)
         valido <- localizarLivro(codigo, quantidade) = NAO_ENCONTRADO
         se nao valido entao
            escreval("Codigo ja cadastrado. Informe outro.")
         fimse
      ate valido
      novo.codigo <- codigo
      repita
         escreva("Titulo: ")
         leia(novo.titulo)
         valido <- compr(novo.titulo) > 0
         se nao valido entao
            escreval("Titulo obrigatorio.")
         fimse
      ate valido
      repita
         escreva("Autor: ")
         leia(novo.autor)
         valido <- compr(novo.autor) > 0
         se nao valido entao
            escreval("Autor obrigatorio.")
         fimse
      ate valido
      novo.ano <- lerInteiro("Ano de publicacao: ", 1, ANO_ATUAL)
      escreval("Categorias: 1 Tecnologia; 2 Exatas; 3 Humanas; 4 Negocios; 5 Literatura")
      novo.categoria <- lerInteiro("Categoria (1 a 5): ", TECNOLOGIA, MAX_CATEGORIAS)
      novo.qtdTotal <- lerInteiro("Quantidade de exemplares (1 a 9999): ", 1, 9999)
      novo.qtdDisponivel <- novo.qtdTotal
      novo.qtdEmprestimos <- 0
      novo.status <- DISPONIVEL
      quantidade <- quantidade + 1
      acervo[quantidade] <- novo
      escreval("Livro cadastrado com sucesso.")
   fimse
fimprocedimento

procedimento listarAcervo(quantidade: inteiro)
var
   i: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio.")
   senao
      para i de 1 ate quantidade faca
         escreval("------------------------------")
         mostrarLivro(i)
      fimpara
   fimse
fimprocedimento

procedimento consultarLivro(quantidade: inteiro)
var
   codigo, posicao: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: nenhum livro para consultar.")
   senao
      codigo <- lerInteiro("Codigo para consulta: ", 1, 999999)
      posicao <- localizarLivro(codigo, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Livro nao encontrado.")
      senao
         mostrarLivro(posicao)
      fimse
   fimse
fimprocedimento

procedimento realizarEmprestimo(quantidade: inteiro)
var
   codigo, posicao, categoria: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: emprestimo impossivel.")
   senao
      codigo <- lerInteiro("Codigo do livro para emprestimo: ", 1, 999999)
      posicao <- localizarLivro(codigo, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Livro inexistente.")
      senao
         se (acervo[posicao].qtdDisponivel <= 0) ou (acervo[posicao].status <> DISPONIVEL) entao
            escreval("Nao ha exemplar disponivel para emprestimo.")
         senao
            acervo[posicao].qtdDisponivel <- acervo[posicao].qtdDisponivel - 1
            acervo[posicao].qtdEmprestimos <- acervo[posicao].qtdEmprestimos + 1
            se acervo[posicao].qtdDisponivel = 0 entao
               acervo[posicao].status <- INDISPONIVEL
            fimse
            categoria <- acervo[posicao].categoria
            movimentacoes[categoria, EMPRESTIMO] <- movimentacoes[categoria, EMPRESTIMO] + 1
            escreval("Emprestimo registrado. Disponiveis: ", acervo[posicao].qtdDisponivel)
         fimse
      fimse
   fimse
fimprocedimento

procedimento realizarDevolucao(quantidade: inteiro)
var
   codigo, posicao, categoria: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: devolucao impossivel.")
   senao
      codigo <- lerInteiro("Codigo do livro para devolucao: ", 1, 999999)
      posicao <- localizarLivro(codigo, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Livro inexistente.")
      senao
         se (qtdEmprestada(posicao) <= 0) ou (acervo[posicao].qtdDisponivel >= acervo[posicao].qtdTotal) entao
            escreval("Nao ha exemplar deste livro para devolver.")
         senao
            acervo[posicao].qtdDisponivel <- acervo[posicao].qtdDisponivel + 1
            acervo[posicao].status <- DISPONIVEL
            categoria <- acervo[posicao].categoria
            movimentacoes[categoria, DEVOLUCAO] <- movimentacoes[categoria, DEVOLUCAO] + 1
            escreval("Devolucao registrada. Disponiveis: ", acervo[posicao].qtdDisponivel)
         fimse
      fimse
   fimse
fimprocedimento

procedimento exibirDisponiveis(quantidade: inteiro)
var
   i, encontrados: inteiro
inicio
   encontrados <- 0
   para i de 1 ate quantidade faca
      se (acervo[i].status = DISPONIVEL) e (acervo[i].qtdDisponivel > 0) entao
         encontrados <- encontrados + 1
         escreval(acervo[i].codigo, " | ", acervo[i].titulo, " | ", acervo[i].qtdDisponivel, " disponiveis")
      fimse
   fimpara
   se encontrados = 0 entao
      escreval("Nenhum livro com exemplar disponivel.")
   fimse
fimprocedimento

// Bubble Sort sobre copias dos registros completos.
// Ordem: emprestimos desc., disponiveis asc., titulo asc., codigo asc.
procedimento montarRanking(quantidade: inteiro)
var
   i, j: inteiro
   auxiliar: TLivro
   trocar: logico
inicio
   para i de 1 ate quantidade faca
      ranking[i] <- acervo[i]
   fimpara
   para i de 1 ate quantidade faca
      para j de 1 ate quantidade - i faca
         trocar <- falso
         se ranking[j].qtdEmprestimos < ranking[j + 1].qtdEmprestimos entao
            trocar <- verdadeiro
         senao
            se ranking[j].qtdEmprestimos = ranking[j + 1].qtdEmprestimos entao
               se ranking[j].qtdDisponivel > ranking[j + 1].qtdDisponivel entao
                  trocar <- verdadeiro
               senao
                  se ranking[j].qtdDisponivel = ranking[j + 1].qtdDisponivel entao
                     se ranking[j].titulo > ranking[j + 1].titulo entao
                        trocar <- verdadeiro
                     senao
                        se (ranking[j].titulo = ranking[j + 1].titulo) e (ranking[j].codigo > ranking[j + 1].codigo) entao
                           trocar <- verdadeiro
                        fimse
                     fimse
                  fimse
               fimse
            fimse
         fimse
         se trocar entao
            auxiliar <- ranking[j]
            ranking[j] <- ranking[j + 1]
            ranking[j + 1] <- auxiliar
         fimse
      fimpara
   fimpara
fimprocedimento

procedimento exibirRanking(quantidade: inteiro)
var
   i: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: ranking indisponivel.")
   senao
      montarRanking(quantidade)
      escreval("POSICAO | LIVRO | AUTOR | EMPRESTIMOS | DISPONIVEIS")
      para i de 1 ate quantidade faca
         escreval(i, " | ", ranking[i].titulo, " | ", ranking[i].autor, " | ", ranking[i].qtdEmprestimos, " | ", ranking[i].qtdDisponivel)
      fimpara
   fimse
fimprocedimento

// Ordena um indice numerico sem alterar a ordem original do acervo.
procedimento montarIndice(quantidade: inteiro)
var
   i, j, codigoAux, posicaoAux: inteiro
   parar: logico
inicio
   para i de 1 ate quantidade faca
      indiceCodigos[i] <- acervo[i].codigo
      indicePosicoes[i] <- i
   fimpara
   para i de 2 ate quantidade faca
      codigoAux <- indiceCodigos[i]
      posicaoAux <- indicePosicoes[i]
      j <- i - 1
      parar <- falso
      enquanto (j >= 1) e (nao parar) faca
         se indiceCodigos[j] > codigoAux entao
            indiceCodigos[j + 1] <- indiceCodigos[j]
            indicePosicoes[j + 1] <- indicePosicoes[j]
            j <- j - 1
         senao
            parar <- verdadeiro
         fimse
      fimenquanto
      indiceCodigos[j + 1] <- codigoAux
      indicePosicoes[j + 1] <- posicaoAux
   fimpara
fimprocedimento

// Casos-base: intervalo vazio ou codigo encontrado no meio.
// Cada chamada reduz o intervalo a metade esquerda ou direita.
funcao buscarBinarioRec(codigo, inicioBusca, fimBusca: inteiro): inteiro
var
   meio: inteiro
inicio
   se inicioBusca > fimBusca entao
      retorne NAO_ENCONTRADO
   senao
      meio <- int((inicioBusca + fimBusca) / 2)
      se indiceCodigos[meio] = codigo entao
         retorne indicePosicoes[meio]
      senao
         se codigo < indiceCodigos[meio] entao
            retorne buscarBinarioRec(codigo, inicioBusca, meio - 1)
         senao
            retorne buscarBinarioRec(codigo, meio + 1, fimBusca)
         fimse
      fimse
   fimse
fimfuncao

procedimento realizarBuscaRecursiva(quantidade: inteiro)
var
   codigo, posicao: inteiro
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: busca impossivel.")
   senao
      montarIndice(quantidade)
      codigo <- lerInteiro("Codigo para busca binaria recursiva: ", 1, 999999)
      posicao <- buscarBinarioRec(codigo, 1, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Livro nao encontrado pela busca recursiva.")
      senao
         mostrarLivro(posicao)
      fimse
   fimse
fimprocedimento

// Percorre a matriz completa com repeticoes aninhadas.
procedimento exibirMatriz(var totalMovimentacoes: inteiro)
var
   categoria, operacao: inteiro
inicio
   totalMovimentacoes <- 0
   escreval("CATEGORIA | EMPRESTIMOS | DEVOLUCOES")
   para categoria de TECNOLOGIA ate MAX_CATEGORIAS faca
      escreva(nomeCategoria(categoria), " | ")
      para operacao de EMPRESTIMO ate DEVOLUCAO faca
         escreva(movimentacoes[categoria, operacao], " | ")
         totalMovimentacoes <- totalMovimentacoes + movimentacoes[categoria, operacao]
      fimpara
      escreval("")
   fimpara
   escreval("Total de movimentacoes: ", totalMovimentacoes)
fimprocedimento

procedimento exibirEstatisticas(quantidade: inteiro)
var
   i, categoria, livrosCategoria, maiorEmp, maiorDisp, categoriaLider: inteiro
   totalExemplares, disponiveis, emprestados, totalEmp, totalDev, totalMov: inteiro
   percentualDisponivel, percentualEmprestado, mediaExemplares: real
inicio
   se quantidade = 0 entao
      escreval("Acervo vazio: nao ha estatisticas.")
   senao
      totalExemplares <- 0
      disponiveis <- 0
      maiorEmp <- 1
      maiorDisp <- 1
      para i de 1 ate quantidade faca
         totalExemplares <- totalExemplares + acervo[i].qtdTotal
         disponiveis <- disponiveis + acervo[i].qtdDisponivel
         se acervo[i].qtdEmprestimos > acervo[maiorEmp].qtdEmprestimos entao
            maiorEmp <- i
         fimse
         se acervo[i].qtdDisponivel > acervo[maiorDisp].qtdDisponivel entao
            maiorDisp <- i
         fimse
      fimpara
      emprestados <- totalExemplares - disponiveis
      totalEmp <- 0
      totalDev <- 0
      categoriaLider <- TECNOLOGIA
      para categoria de TECNOLOGIA ate MAX_CATEGORIAS faca
         totalEmp <- totalEmp + movimentacoes[categoria, EMPRESTIMO]
         totalDev <- totalDev + movimentacoes[categoria, DEVOLUCAO]
         se movimentacoes[categoria, EMPRESTIMO] > movimentacoes[categoriaLider, EMPRESTIMO] entao
            categoriaLider <- categoria
         fimse
      fimpara
      percentualDisponivel <- (disponiveis * 100) / totalExemplares
      percentualEmprestado <- (emprestados * 100) / totalExemplares
      mediaExemplares <- totalExemplares / quantidade
      escreval("Livros cadastrados: ", quantidade)
      escreval("Exemplares totais: ", totalExemplares)
      escreval("Exemplares disponiveis: ", disponiveis)
      escreval("Exemplares emprestados agora: ", emprestados)
      escreval("Emprestimos acumulados: ", totalEmp)
      escreval("Devolucoes acumuladas: ", totalDev)
      escreval("Percentual disponivel: ", percentualDisponivel:0:2, "%")
      escreval("Percentual emprestado: ", percentualEmprestado:0:2, "%")
      escreval("Media de exemplares por livro: ", mediaExemplares:0:2)
      escreval("Mais emprestado: ", acervo[maiorEmp].titulo, " (", acervo[maiorEmp].qtdEmprestimos, ")")
      escreval("Mais disponivel: ", acervo[maiorDisp].titulo, " (", acervo[maiorDisp].qtdDisponivel, ")")
      para categoria de TECNOLOGIA ate MAX_CATEGORIAS faca
         livrosCategoria <- 0
         para i de 1 ate quantidade faca
            se acervo[i].categoria = categoria entao
               livrosCategoria <- livrosCategoria + 1
            fimse
         fimpara
         escreval(nomeCategoria(categoria), ": ", livrosCategoria, " livros; ", movimentacoes[categoria, EMPRESTIMO], " emprestimos; ", movimentacoes[categoria, DEVOLUCAO], " devolucoes")
      fimpara
      escreval("Categoria lider em emprestimos: ", nomeCategoria(categoriaLider))
      exibirMatriz(totalMov)
   fimse
fimprocedimento

inicio
   totalLivros <- 0
   para opcao de TECNOLOGIA ate MAX_CATEGORIAS faca
      movimentacoes[opcao, EMPRESTIMO] <- 0
      movimentacoes[opcao, DEVOLUCAO] <- 0
   fimpara
   repita
      escreval("")
      escreval("UNILIBRARY - SISTEMA DE GERENCIAMENTO DE BIBLIOTECA")
      escreval("1. Cadastrar livro")
      escreval("2. Listar acervo")
      escreval("3. Consultar livro")
      escreval("4. Realizar emprestimo")
      escreval("5. Realizar devolucao")
      escreval("6. Exibir livros disponiveis")
      escreval("7. Exibir ranking do acervo")
      escreval("8. Exibir estatisticas")
      escreval("9. Realizar busca recursiva")
      escreval("10. Encerrar sistema")
      opcao <- lerInteiro("Opcao: ", 0, 99)
      escolha opcao
         caso 1
            cadastrarLivro(totalLivros)
         caso 2
            listarAcervo(totalLivros)
         caso 3
            consultarLivro(totalLivros)
         caso 4
            realizarEmprestimo(totalLivros)
         caso 5
            realizarDevolucao(totalLivros)
         caso 6
            exibirDisponiveis(totalLivros)
         caso 7
            exibirRanking(totalLivros)
         caso 8
            exibirEstatisticas(totalLivros)
         caso 9
            realizarBuscaRecursiva(totalLivros)
         caso 10
            escreval("Sistema encerrado.")
         outrocaso
            escreval("Opcao inexistente. Escolha de 1 a 10.")
      fimescolha
   ate opcao = 10
fimalgoritmo
