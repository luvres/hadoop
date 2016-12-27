# Regressão Linear Múltipla em linguagem Julia

using Gadfly

# Função para Normalizar os atributos
function featureNormalize(x)
rows = size(x,1)
cols = size(x,2)

μ = mean(x,1)
σ = std(x,1)
xNorm = zeros(x)

# Normalizando
for i in 1:cols
	for j in 1:rows
		xNorm[j,i] = (x[j,i] - μ[i]) / σ[i];
	end
end

(xNorm, μ, σ)
end


println("Carregando os dados ... ")
data = readdlm("data.txt",',')
x = data[:,1:2]
y = data[:, 3]
m = length(y)

@printf("Primeiros 10 exemplos do dataset: \n");
t = [x[1:10,:] y[1:10,:]]'
for i in 1:10
  @printf(" x = [%.0f %.0f], y = %.0f \n", t[1,i], t[2,i], t[3,i]);
end

# Escala os atributos e configura para média zero
(x, μ, σ) = featureNormalize(x);

# Adiciona o coeficiente de inetrcepto a x
x = [ones(m,1) x]

#### Executa o Gradient Descent
α = 0.001
numIter = 4000
θ = zeros(3,1)
jHist = zeros(numIter, 1)

for i in 1:numIter
  # next theta
  θ = θ - (α/m) * (x' * ((x*θ)-y))
  # compute cost
  jHist[i] = sum((x*θ-y).^2)/(2m)
end

# Plot dos erros
pl = plot(
  x=collect(1:numIter),
  y=jHist,
  Guide.xlabel("Iterações"),
  Guide.ylabel("Erro"),
  Guide.title("Gráfico de Convergência"),
  Geom.line
  )
draw(SVGJS("grafico.js.svg", 6inch, 6inch), pl)

# Estimativa do preço de uma casa de 1650 sq-ft e 3 quartos
price = [1, (1650-μ[1])/σ[1], (3-μ[2])/σ[2]]' * θ
println("Estimativa do preço de uma casa de 1650 sq-ft e 3 quartos: $price")

println("Concluído!")
