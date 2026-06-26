import { prisma } from "../database/prisma.js";

// Categorías orientadas a trabajadores informales (oficios manuales,
// servicios del hogar, cuidado de personas, etc.), sin cerrar la puerta
// a servicios más formales/profesionales.
const dataset = [
  {
    name: "Construcción y reparaciones",
    specifics: [
      "Albañilería",
      "Plomería/Gasfitería",
      "Electricidad",
      "Pintura",
      "Carpintería",
      "Techado",
      "Soldadura",
      "Instalación de pisos",
    ],
  },
  {
    name: "Limpieza",
    specifics: [
      "Limpieza del hogar",
      "Limpieza de oficinas",
      "Limpieza profunda/post-construcción",
      "Limpieza de vidrios y fachadas",
      "Lavado de tapicería y alfombras",
    ],
  },
  {
    name: "Cuidado personal y del hogar",
    specifics: [
      "Niñera/cuidado infantil",
      "Cuidado de adultos mayores",
      "Cuidado de personas con discapacidad",
      "Chef/cocina a domicilio",
      "Planchado y lavado de ropa",
    ],
  },
  {
    name: "Mecánica y vehículos",
    specifics: [
      "Mecánica automotriz",
      "Mecánica de motos",
      "Lavado de autos",
      "Electricidad automotriz",
      "Cerrajería",
    ],
  },
  {
    name: "Belleza y estética",
    specifics: [
      "Peluquería",
      "Manicure y pedicure",
      "Maquillaje",
      "Masajes",
      "Barbería",
    ],
  },
  {
    name: "Transporte y mudanzas",
    specifics: [
      "Mudanzas",
      "Fletes y carga",
      "Mandados/mototaxi",
      "Conductor particular",
    ],
  },
  {
    name: "Jardinería y exteriores",
    specifics: [
      "Jardinería",
      "Poda de árboles",
      "Fumigación y control de plagas",
      "Limpieza de piscinas",
    ],
  },
  {
    name: "Tecnología y electrónica",
    specifics: [
      "Reparación de celulares",
      "Reparación de computadoras",
      "Instalación de cámaras de seguridad",
      "Soporte técnico a domicilio",
    ],
  },
  {
    name: "Eventos y gastronomía",
    specifics: [
      "Catering",
      "Repostería",
      "Decoración de eventos",
      "Animación/DJ",
      "Fotografía y video",
    ],
  },
  {
    name: "Educación y tutorías",
    specifics: [
      "Clases particulares (primaria/secundaria)",
      "Clases de idiomas",
      "Clases de música",
      "Preparación para exámenes",
    ],
  },
  {
    name: "Mascotas",
    specifics: [
      "Paseo de perros",
      "Peluquería canina",
      "Cuidado de mascotas (pet-sitting)",
      "Adiestramiento",
    ],
  },
];

// Los 11 municipios oficiales de la subregión de Urabá (Antioquia).
const locations = [
  "Apartadó",
  "Turbo",
  "Chigorodó",
  "Carepa",
  "Necoclí",
  "Arboletes",
  "San Juan de Urabá",
  "San Pedro de Urabá",
  "Mutatá",
  "Murindó",
  "Vigía del Fuerte",
];

async function main() {
  console.log("Limpiando categorías existentes...");
  // Hay que limpiar primero las tablas que referencian a las categorías
  // (posts y trabajadores ya etiquetados), si no, el RESTRICT del FK falla.
  await prisma.postCategory.deleteMany();
  await prisma.workerCategory.deleteMany();
  await prisma.categoryHierarchy.deleteMany();
  await prisma.specificCategory.deleteMany();
  await prisma.generalCategory.deleteMany();

  const specificCache = new Map();

  for (const general of dataset) {
    const createdGeneral = await prisma.generalCategory.create({
      data: { name: general.name },
    });

    for (const specificName of general.specifics) {
      let specificId = specificCache.get(specificName);

      if (!specificId) {
        const createdSpecific = await prisma.specificCategory.create({
          data: { name: specificName },
        });
        specificId = createdSpecific.id;
        specificCache.set(specificName, specificId);
      }

      await prisma.categoryHierarchy.create({
        data: {
          generalCategoryId: createdGeneral.id,
          specificCategoryId: specificId,
        },
      });
    }
  }

  console.log("Categorías insertadas correctamente.");

  console.log("Limpiando ubicaciones existentes...");
  await prisma.location.deleteMany();

  await prisma.location.createMany({
    data: locations.map((name) => ({ name })),
  });

  console.log("Ubicaciones insertadas correctamente.");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
