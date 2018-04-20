const meow = require('meow');
const server = require('.');

const cli = meow(`

`);

main(cli)
  .catch(err => {
    if (err.managed) {
      console.error(err.message);
      return process.exit(1);
    }
    throw err;
  });

async function main(cli) {
  const app = await server({
    redirectPort: cli.flags.redirectPort || process.env.REDIRECTPORT || 1338,
    port: cli.flags.port || process.env.PORT || 1337,
    public: cli.flags.public || './public'
  });

  console.log(`Started ${cli.pkg.name} server at http://localhost:${app.port}:${app.redirectPort}`);
}
