using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using sample_web_app.Models;
using sample_web_app.Services;
namespace sample_web_app.Pages
{
    public class PizzaModel : PageModel
    {
        public void OnGet()
        {
          pizzas = PizzaService.GetAll();
        }

        [BindProperty]
        public Pizza NewPizza { get; set; }

        public List<Pizza> pizzas;

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }
            PizzaService.Add(NewPizza);
            return RedirectToAction("Get");
        }

        public string GlutenFreeText(Pizza pizza)
        {
            if (pizza.IsGlutenFree)
                return "Gluten Free";
            return "Not Gluten Free";
        }

        public IActionResult OnPostDelete(int id)
        {
            PizzaService.Delete(id);
            return RedirectToAction("Get");
        }
    }
}
