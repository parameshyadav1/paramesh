package pizzaApplication.com;

public class DeluxPizza extends pizza{
    @Override
    public void addExtraCheese() {
        this.price += extraCheesePrice;
    }

    @Override
    public void addExtraToppings() {
       this.price += extraToppingdPrice;
    }

    public DeluxPizza(Boolean veg) {
        super(veg);

    }
}


package pizzaApplication.com;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println("--------------------Welcome to domonis pizza---------------------\n");
        System.out.println("Which Pizza:  (1.veg Pizza    2.Non-veg pizza  3.Delux pizza  4Delux Non-veg pizza)  ===>");
        Scanner sc = new Scanner(System.in);
        int ch = sc.nextInt();

        switch (ch){
            case 1:
                pizza vegPizza = new pizza(true);
                vegPizza.addExtraToppings();
                vegPizza.addExtraCheese();
                vegPizza.takeAway();
                vegPizza.getBill();
                break;

            case 2:
                pizza nonVegPizza = new pizza(false);
                nonVegPizza.addExtraToppings();
                nonVegPizza.addExtraCheese();
                nonVegPizza.takeAway();
                nonVegPizza.getBill();
                break;

            case 3:
                DeluxPizza veg = new DeluxPizza(true);
                veg.basePizzaPrice =550;
                veg.addExtraToppings();
                veg.addExtraCheese();
                veg.takeAway();
                veg.getBill();
                break;


            case 4:
                DeluxPizza nonVeg = new DeluxPizza(true);
                nonVeg.basePizzaPrice =550;
                nonVeg.addExtraToppings();
                nonVeg.addExtraCheese();
                nonVeg.takeAway();
                nonVeg.getBill();
                break;

        }
    }
}


package pizzaApplication.com;

import java.util.Scanner;

public class pizza {
    protected  int price;
    private Boolean veg;

    protected int extraCheesePrice= 100;
    protected  int extraToppingdPrice= 150;
    protected  int backPackPrice = 20;

    protected  int basePizzaPrice;

    private boolean isExtraCheeseAdded = false;
    private  boolean isExtraToppingsAdded = false;
    private  boolean isOpetedForTakeWay =false;

    Scanner in = new Scanner(System.in);

    public  pizza(Boolean veg){
        this.veg = veg;
        if (this.veg){
            this.price =300;
        }
        else {
            this.price=400;
        }
        basePizzaPrice =this.price;
    }

    public void addExtraCheese() {
        System.out.println("Extra cheese (y/n)? =>");
        char ch = in.next().charAt(0);
        switch (ch) {
            case ('y'):
                isExtraCheeseAdded = true;
                this.price += extraCheesePrice;
                break;
            case ('n'):
                isExtraCheeseAdded = false;
                break;
        }
    }
        public void addExtraToppings(){
            System.out.println("Want Extra Topping (y/n)? =>");
            char ch = in.next().charAt(0);
            switch (ch){
                case ('y'):
                    isExtraToppingsAdded = true;
                    this.price += extraCheesePrice;
                    break;
                case ('n'):
                    isExtraToppingsAdded= false;
                    break;
            }
    }
       public void takeAway() {
           System.out.println("Want TakeAway (y/n)? =>");
           char ch = in.next().charAt(0);
           switch (ch) {
               case ('y'):
                   isOpetedForTakeWay = true;
                   this.price += backPackPrice;
                   break;
               case ('n'):
                   isOpetedForTakeWay = false;
                   break;
           }
       }

       public void getBill(){

        String bill = " ";

        System.out.println("Pizza : "+basePizzaPrice);
        if (isExtraCheeseAdded){
            bill += "Extra cheese : "+extraCheesePrice+ "\n";
        }
        if(isExtraToppingsAdded){
            bill += "Extra Toppings : "+extraToppingdPrice+ "\n";
        }
        if(isOpetedForTakeWay){
            bill += "Take away : "+backPackPrice+ "\n";
        }
        bill += "nTotal Amunt: "+ this.price +"\n";

           System.out.println(bill);
           System.out.println("\n\n\nThanks you!!! Visit Again.........");
           System.out.println("..................................................");
       }
}
