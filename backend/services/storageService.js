// upload.js
const bucket = require('./firebase');
const path = require('path');
const fs = require('fs');

async function uploadFile(localFilePath, destinationFileName) {
  await bucket.upload(localFilePath, {
    destination: destinationFileName,
    public: true, // Opcional: para que el archivo sea accesible públicamente
    metadata: {
      cacheControl: 'public, max-age=31536000',
    },
  });

  const file = bucket.file(destinationFileName);
  const publicUrl = `https://storage.googleapis.com/${bucket.name}/${destinationFileName}`;
  
  return publicUrl;
}

// Ejemplo de uso:
uploadFile('./uploads/ejemplo.jpg', 'imagenes/ejemplo.jpg')
  .then(url => console.log('Archivo subido, URL pública:', url))
  .catch(err => console.error('Error al subir:', err));
