require 'pry'

def consolidate_cart(cart)
  newCart = {}

  cart.each do |item|
    itemName = item.keys[0]
    clearance = item.values[0][:clearance]
    price = item.values[0][:price]
    if newCart[itemName]
        newCart[itemName][:count] += 1
    else
      newCart[itemName] = {
        :price => price,
        :clearance => clearance,
        :count => 1
      }
    end
  end
newCart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    itemName = coupon[:item]
    cuponCount = coupon[:num]
    
    if cart[itemName] && cuponCount <= cart[itemName][:count]
      if cart["#{itemName} W/COUPON"]
        # binding.pry
        cart["#{itemName} W/COUPON"][:count] += cuponCount
      else
        cart["#{itemName} W/COUPON"] = {
          :price => coupon[:cost] / cuponCount,
          :clearance => cart[itemName][:clearance],
          :count => cuponCount
        }
      end
      cart[itemName][:count] -= cuponCount
    end
    # binding.pry
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    
    if info[:clearance]
      # binding.pry
     cart[item][:price] = (info[:price] * 8) /10
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  
  conCart = consolidate_cart(cart)
  
  couponCart = apply_coupons(conCart, coupons)
  
  finalCart = apply_clearance(couponCart)

  finalCart.each do |item, info|
    total += finalCart[item][:price] * finalCart[item][:count]
  end
  # binding.pry
  total > 100 ? total = (total * 9 ) / 10 : total
end
