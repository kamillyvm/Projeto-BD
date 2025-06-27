CREATE TABLE Produto (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Preco FLOAT
);

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Email VARCHAR(255)
);

CREATE TABLE VendaCompra (
    VendaCompraID INT PRIMARY KEY,
    ClienteID INT,
	ProdutoID INT,
	PrecoTotal INT,
    Data DATE,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE Material (
    MaterialID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE ProdutoMaterial (
    ProdutoID INT,
    MaterialID INT,
    PRIMARY KEY (ProdutoID, MaterialID),
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID),
    FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

INSERT INTO Produto (ProdutoID, Nome, Preco) VALUES
(1, 'Sapato', 20.00),
(2, 'All Star', 30.00);

INSERT INTO Cliente (ClienteID, Nome, Email) VALUES
(1, 'Joao', 'joao1@example.com'),
(2, 'Mateus', 'mateus2@example.com');

INSERT INTO Material (MaterialID, Nome) VALUES
(1, 'Veludo'),
(2, 'Jeans');

INSERT INTO ProdutoMaterial (ProdutoID, MaterialID) VALUES
(1, 1),
(2, 2);

INSERT INTO VendaCompra (VendaCompraID, ClienteID, ProdutoID, Data, PrecoTotal) VALUES
(1, 1, 1, '2023-12-15', 20.00),
(2, 2, 2, '2023-12-16', 30.00);

SELECT
VendaCompra.VendaCompraID,
Cliente.Nome AS NomeCliente,
Produto.Nome AS NomeProduto,
VendaCompra.Data,
VendaCompra.PrecoTotal
FROM
VendaCompra
JOIN Cliente ON VendaCompra.ClienteID = Cliente.ClienteID
JOIN Produto ON VendaCompra.ProdutoID = Produto.ProdutoID;


CREATE VIEW DetalhesVenda AS
SELECT
    VendaCompra.VendaCompraID,
    Cliente.Nome AS NomeCliente,
    Produto.Nome AS NomeProduto,
    VendaCompra.Data,
    VendaCompra.PrecoTotal
FROM
    VendaCompra
JOIN Cliente ON VendaCompra.ClienteID = Cliente.ClienteID
JOIN Produto ON VendaCompra.ProdutoID = Produto.ProdutoID;



CREATE TRIGGER AtualizarPrecoTotal
BEFORE INSERT ON VendaCompra
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(Preco) INTO total
    FROM Produto
    WHERE ProdutoID = NEW.ProdutoID;
    SET NEW.PrecoTotal = total;
END;