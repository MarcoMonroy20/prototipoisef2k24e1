using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Modelo_Vista_AsistenciaYFaltas
{
    public partial class frm_permisos : Form
    {
        public frm_permisos()
        {
            InitializeComponent();
            string idUsuario = Interfac_V3.UsuarioSesion.GetIdUsuario();
            /// Marco Alejandro Monroy*/
            /*Prueba con navegador*/
            string[] alias = { "codigo_sede", " nombre_sede", "estatus_sede",  " estado", };
            navegador1.AsignarAlias(alias);
            navegador1.AsignarSalida(this);
            navegador1.AsignarColorFondo(ColorTranslator.FromHtml("#B4D2F0"));
            navegador1.AsignarColorFuente(Color.Black);
            navegador1.AsignarTabla("sedes");
            navegador1.ObtenerIdAplicacion("16012");
            navegador1.ObtenerIdUsuario(idUsuario);
            navegador1.AsignarAyuda("1");
            navegador1.AsignarNombreForm("Asignacion de Sedes");


           
        }

        private void navegador1_Load(object sender, EventArgs e)
        {

        }
    }
}
