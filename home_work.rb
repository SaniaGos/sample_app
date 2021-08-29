
class String

  def string_shuffle
    self.split('').shuffle.join
  end
end

p "foobar".string_shuffle

person1 = {first: "Oleksandr", last: "Hutsenko"}
person2 = {first: "Bogdana", last: "Hutsenko"}
person3 = {first: "Iyriy", last: "Hutsenko"}

p params = {father: person1, mother: person2, child: person3}
p params[:father][:first]