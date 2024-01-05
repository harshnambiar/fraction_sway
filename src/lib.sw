library;

use std::primitive_conversions::u64::*;



 
pub struct Fraction {
    sign: bool,
    num: u64,
	den: u64,
}

impl Fraction {
    // creates a fraction with said sign and numerator and denominator
	fn to(s: bool, n: u64, d: u64) -> Fraction {
		let fr = Fraction {
			sign: s,
			num: n,
			den: d,
		};
		return fr;
	}

	// fetches the numerator of the fraction
	fn numerator(f: Fraction) -> u64 {
		return f.num;
	}

	// fetches the denominator of the fraction
	fn denominator(f: Fraction) -> u64 {
		return f.den;
	}

	// fetches the sign of the fraction, with true being positive and false being negative values
	fn sn(f: Fraction) -> bool {
		return f.sign;
	}

	// returns 0 as a fraction
	fn zero() -> Fraction {
		let fr = Fraction {
			sign: true,
			num: 0,
			den: 1,
		};
		return fr;
	}

	// returns 1 as a fraction
	fn one() -> Fraction {
		let fr = Fraction {
			sign: true,
			num: 1,
			den: 1,
		};
		return fr;
	}

	// returns -1 as a fraction
	fn minus_one() -> Fraction {
		let fr = Fraction {
			sign: false,
			num: 1,
			den: 1,
		};
		return fr;
	}

	// returns a fraction with the same value but opposite sign
	fn reverse_sign(f: Fraction) -> Fraction {
		let fr = Fraction {
			sign: !f.sign,
			num: f.num,
			den: f.den,
		};
		return fr;
	}

	fn invert(f: Fraction) -> Fraction {
		assert(f.den != 0);
		let fr = Fraction {
			sign: f.sign,
			num: f.den,
			den: f.num,
		};
		return fr;
	}

	// this method will only work till numerator and denominator values are under 100
	// this has been set for efficiency reasons, and will be modified once the Noir team
	// can implement dynamic limit for loops
	fn reduce(f: Fraction) -> Fraction {
		let mut a = f.num;
		let mut b = f.den;
		let mut min = 0;
		let mut j = 1;
		let mut gcd = 1;
		if a > b {
			min = b;
		}
		else {
			min = a;
		}
		
		while j <= min {
			
			
			if (a%j == 0) && (b%j == 0){
				gcd = j;
			}
			j += 1;
			
		}
		
		
		let fr = Fraction {
			sign: f.sign,
			num: f.num/gcd,
			den: f.den/gcd,
		};
		fr
	}

	// Multiplies two fractions
	fn multiply(f1: Fraction, f2: Fraction) -> Fraction {
		let mut an: u256 = f1.num.as_u256();
		let mut ad: u256 = f1.den.as_u256();
		let mut bn: u256 = f2.num.as_u256();
		let mut bd: u256 = f2.den.as_u256();
		let mut m = f1;
		let mut n = f2;
		let lim = 2000000000.as_u256();
		

		if ((an*bn > lim) || (ad*bd > lim)) {
			m = Fraction::reduce(m);
			n = Fraction::reduce(n);
		}

		an = m.num.as_u256();
		ad = m.den.as_u256();
		bn = n.num.as_u256();
		bd = n.den.as_u256();

		
		if ((an*bn > lim) || (ad*bd > lim)) {
			let mut c = Fraction{ sign: m.sign, num: m.num, den: n.den};
			let mut d = Fraction{ sign: n.sign, num: n.num, den: m.den};
			c = Fraction::reduce(c);
			d = Fraction::reduce(d);
			an = c.num.as_u256();
			ad = c.den.as_u256();
			bn = d.num.as_u256();
			bd = d.den.as_u256();
		}

		
		let mut ddd = (an*bn)/(ad*bd);
		let mut factor: u64 = 1;
		let mut i = 1;
		while i < 5{
			if ddd*10.as_u256() < lim {
				factor *= 10;
				ddd = ddd * 10.as_u256();
			}
			i += 1;
		}
		
		if ((an*bn > lim) || (ad*bd > lim)) {
			

			let np256 = ((an*bn*factor.as_u256())/(ad*bd));
			let np = u64::try_from(np256).unwrap();
			let fr = Fraction{
				sign: (f1.sign == f2.sign),
				num: np,
				den: factor,
			};
			fr
			
		}
		else {
			let fr = Fraction {
				sign: (m.sign == n.sign),
				num: m.num*n.num,
				den: m.den*n.den,
			};
			fr
			
		}
		
		
	}

	// Divides the first fraction by the second and outputs the quotient
	fn divide(f1: Fraction, f2: Fraction) -> Fraction {
		assert (f2.num != 0);
		let f3 = Fraction {
			sign: f2.sign,
			num: f2.den,
			den: f2.num,
		};
		let fr = Fraction::multiply(f1, f3);
		
		fr
	}

	

    
}

#[test]
fn test_create_fraction() {
    let f = Fraction::to(true, 7, 10);
	assert(f.num == 7);
	assert (f.den == 10);
}

#[test]
fn test_create_zero() {
    let f = Fraction::zero();
	assert(f.num == 0);
	assert(f.sign);
}

#[test]
fn test_create_one() {
    let f = Fraction::one();
	assert(f.num == f.den);
	assert(f.sign);
}

#[test]
fn test_create_minus_one() {
    let f = Fraction::minus_one();
	assert(f.num == f.den);
	assert(!f.sign);
}

#[test]
fn test_reverse_sign(){
    let f= Fraction::to(true, 7, 5);
    let frev = Fraction::reverse_sign(f);
    assert (frev.num == 7);
    assert (frev.sign != f.sign);
}


/*
#[test]
fn test_mul() {
    let f1 = Fraction::to(true, 1, 5);
    let f2 = Fraction::to(true, 5, 1);
    let f = Fraction::multiply(f1, f2);
    assert(f.num == f.den);
}
*/

#[test]
fn test_inv() {
    let f1 = Fraction::to(false, 1, 5);
    let finv = Fraction::invert(f1);
    assert (finv.num == 5);
	assert (finv.den == 1);
	assert (!finv.sign);
    
}

#[test]
fn test_reduce() {
    let f1 = Fraction::to(false, 10, 50);
    let fred = Fraction::reduce(f1);
    assert (fred.num == 1);
	assert (fred.den == 5);
	assert (!fred.sign);
    
}

/*
#[test]
fn test_div() {
    let f1 = Fraction::to(true, 6, 5);
    let f2 = Fraction::to(true, 5, 1);
    let f = Fraction::divide(f1, f2);
    assert (f.num == 6);
    assert (f.den == 25);
}
*/