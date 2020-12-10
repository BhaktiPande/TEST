using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(InsiderTrading.Startup))]
namespace InsiderTrading
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
