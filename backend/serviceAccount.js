import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export default JSON.parse(
    readFileSync(join(__dirname, 'serviceAccount.json'), 'utf-8')
);
