
| Field          | Type          | Description                                                                |
|----------------|---------------|----------------------------------------------------------------------------|
| `title`        | `string`      | Título del artículo.                                                       |
| `urlToImage`   | `string`      | URL de la imagen del artículo en Firebase Storage (`media/articles`).      |
| `content`      | `string`      | Contenido completo del artículo.    

ArticleSchema = { 
  "title": "The Future of NoSQL Databases",
  "urlToImage": "media/articles/future-nosql-thumbnail.jpg",
  "content": "NoSQL databases offer flexible schemas for modern applications..."
}