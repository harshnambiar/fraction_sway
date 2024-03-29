library;

use std::primitive_conversions::u64::*;

use std::logging::log;


 
pub struct Fraction {
    sign: bool,
    num: u64,
	den: u64,
}



fn reduction(f: Fraction) -> Fraction {
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

impl Fraction {
    // creates a fraction with said sign and numerator and denominator
	fn to(s: bool, n: u64, d: u64) -> Self {
		let fr = Self {
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

	// reduces a fraction to its standard form where the numerator and denominator have no
	// common factor other than 1
	fn reduce(f: Self) -> Self {
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
		
		
		let fr = Self {
			sign: f.sign,
			num: f.num/gcd,
			den: f.den/gcd,
		};
		fr
	}

	// approximates the given fraction to the closest fraction with 10000 as the denominator
	fn approximate(f: Fraction) -> Fraction {
		if (f.num < 10000 && f.den < 10000) {
			return f;
		}
		
		else {
			let num256: u256 = f.num.as_u256();
			let den256: u256 = f.den.as_u256();
			let apprx_num = ((num256 * 10000.as_u256())/(den256));
			let fr = Fraction {
				sign: f.sign,
				num: u64::try_from(apprx_num).unwrap(),
				den: 10000,
			};
			return fr;
		}
		
	}

	// compares two Fractions
	// returns 0 if they are equal
	// returns 1 if the first argument is greater
	// returns 2 if the second argument is greater
	fn compare(f1: Fraction, f2: Fraction) -> u32 {
		if ((f1.num == f2.num) && (f1.num == 0)){
			return 0;
		}
		else {
			if (f1.sign != f2.sign){
				if (f1.sign){
					return 1;
				}
				else {
					return 2;
				}
			}
			else {
				
				if ((f1.num*f2.den) > (f2.num*f1.den)){
					if (f1.sign){
						return 1;
					}
					else {
						return 2;
					}
				}
				else {
					
					if ((f1.num*f2.den) != (f2.num*f1.den)){
						if (f1.sign){
							return 2;
						}
						else {
							return 1;
						}
					}
					else {
						return 0;
					}
					
				}
				
			}
		}
	}

	// Multiplies two fractions
	fn multiply(f1: Self, f2: Self) -> Self {
		let mut an: u256 = f1.num.as_u256();
		let mut ad: u256 = f1.den.as_u256();
		let mut bn: u256 = f2.num.as_u256();
		let mut bd: u256 = f2.den.as_u256();
		let mut m = f1;
		let mut n = f2;
		let lim = 2000000000.as_u256();
		
		if ((an*bn > lim) || (ad*bd > lim)) {
			m = reduction(m);
			n = reduction(n);
		}
		
		
		an = m.num.as_u256();
		ad = m.den.as_u256();
		bn = n.num.as_u256();
		bd = n.den.as_u256();

		
		
		if ((an*bn > lim) || (ad*bd > lim)) {
			let mut c = Fraction{ sign: m.sign, num: m.num, den: n.den};
			let mut d = Fraction{ sign: n.sign, num: n.num, den: m.den};
			c = reduction(c);
			d = reduction(d);
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
		let mut an: u256 = f1.num.as_u256();
		let mut ad: u256 = f1.den.as_u256();
		let mut bn: u256 = f2.den.as_u256();
		let mut bd: u256 = f2.num.as_u256();
		let mut m = f1;
		let mut n = Fraction{sign: f2.sign, num: f2.den, den: f2.num};
		let lim = 2000000000.as_u256();
		
		if ((an*bn > lim) || (ad*bd > lim)) {
			m = reduction(m);
			n = reduction(n);
		}
		
		
		an = m.num.as_u256();
		ad = m.den.as_u256();
		bn = n.num.as_u256();
		bd = n.den.as_u256();

		
		
		if ((an*bn > lim) || (ad*bd > lim)) {
			let mut c = Fraction{ sign: m.sign, num: m.num, den: n.den};
			let mut d = Fraction{ sign: n.sign, num: n.num, den: m.den};
			c = reduction(c);
			d = reduction(d);
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

	// returns the square of the given fraction
	fn square(f: Fraction) -> Fraction {
		let lim = 2000000000.as_u256();
		let n = f.num.as_u256();
		let d = f.den.as_u256();
		if ((n*n >= lim) || (d*d >= lim)) {
			let new_num = (n*n*10000.as_u256())/(d*d);
			let fr = Fraction {
				sign: true,
				num: u64::try_from(new_num).unwrap(),
				den: 10000,
			};
			return fr;
		}
		else {
			let fr = Fraction {
				sign: true,
				num: f.num * f.num,
				den: f.den * f.den,
			};
			return fr;
		}
		
	}

	// Adds two fractions
	fn add(f1: Fraction, f2: Fraction) -> Fraction {
		let mut an: u256 = f1.num.as_u256();
		let mut ad: u256 = f1.den.as_u256();
		let mut bn: u256 = f2.num.as_u256();
		let mut bd: u256 = f2.den.as_u256();
		let mut m = f1;
		let mut n = f2;
		let lim = 2000000000.as_u256();

		if f1.sign == f2.sign {
		
			if ((ad*bd > lim) || ((an*bd + ad*bn) > lim)){
				m = reduction(m);
				n = reduction(n);
			}
			an = m.num.as_u256();
			ad = m.den.as_u256();
			bn = n.num.as_u256();
			bd = n.den.as_u256();
			if ((ad*bd > lim) || ((an*bd + ad*bn) > lim)){
				let mut ddd = (an*bd + ad*bn)/(ad*bd);
				let mut factor: u64 = 1;
				let mut i: u8 = 1;
				while i < 5 {
					if ddd*10.as_u256() < lim {
						ddd *= 10.as_u256();
						factor *= 10;
					}
					i += 1;
				};
				let np256 = (((an*bd + ad*bn)*factor.as_u256())/(ad*bd));
				let np = u64::try_from(np256).unwrap();
				let fr = Fraction {
					sign: f1.sign,
					num: np,
					den: factor, 
				};
				return fr;
			}
			else {
				let fr = Fraction {
					sign: f1.sign,
					num: (m.num*n.den + n.num*m.den),
					den: m.den*n.den,
				};
				return fr;
			}
			
			
		}
		else {

			if ((an*bd) > (bn*ad)){
				if ((ad*bd > lim) || ((an*bd - ad*bn) > lim) || (an*bd > lim)){
					m = reduction(m);
					n = reduction(n);
				}
				an = m.num.as_u256();
				ad = m.den.as_u256();
				bn = n.num.as_u256();
				bd = n.den.as_u256();
				if ((ad*bd > lim) || ((an*bd - ad*bn) > lim) || (an*bd > lim)){
					let mut ddd = (an*bd - ad*bn)/(ad*bd);
					let mut factor: u64 = 1;
					let mut i: u8 = 1;
					while i < 5 {
						if ddd*10.as_u256() < lim {
							ddd *= 10.as_u256();
							factor *= 10;
						}
						i += 1;
					};
					let np256 = (((an*bd - ad*bn)*factor.as_u256())/(ad*bd));
					let np = u64::try_from(np256).unwrap();
					let fr = Fraction {
						sign: f1.sign,
						num: np,
						den: factor, 
					};
					fr
				}
				else {
					let fr = Fraction {
						sign: f1.sign,
						num: (m.num*n.den - n.num*m.den),
						den: m.den*n.den,
					};
					fr
				}
			}
			else {
				if ((ad*bd > lim) || ((bn*ad - bd*an) > lim) || (bn*ad > lim)){
					m = reduction(m);
					n = reduction(n);
				}
				an = m.num.as_u256();
				ad = m.den.as_u256();
				bn = n.num.as_u256();
				bd = n.den.as_u256();
				if ((ad*bd > lim) || ((bn*ad - bd*an) > lim) || (bn*ad > lim)){
					let mut ddd = (bn*ad - bd*an)/(ad*bd);
					let mut factor: u64 = 1;
					let mut i: u8 = 1;
					while i < 5 {
						if ddd*10.as_u256() < lim {
							ddd *= 10.as_u256();
							factor *= 10;
						}
						i += 1;
					};
					let np256 = (((bn*ad - bd*an)*factor.as_u256())/(ad*bd));
					let np = u64::try_from(np256).unwrap();
					let fr = Fraction {
						sign: f2.sign,
						num: np,
						den: factor, 
					};
					fr
				}
				else {
					let fr = Fraction {
						sign: f2.sign,
						num: (n.num*m.den - m.num*n.den),
						den: m.den*n.den,
					};
					fr
				}
			}
		}
	}


	// Subtracts the second fraction from the first
	fn subtract(f1: Fraction, f2: Fraction) -> Fraction {
		let f3 = Fraction {sign: !f2.sign, num: f2.num, den: f2.den};
		let mut an: u256 = f1.num.as_u256();
		let mut ad: u256 = f1.den.as_u256();
		let mut bn: u256 = f2.num.as_u256();
		let mut bd: u256 = f2.den.as_u256();
		let mut m = f1;
		let mut n = f3;
		let lim = 2000000000.as_u256();

		if f1.sign == f3.sign {
		
			if ((ad*bd > lim) || ((an*bd + ad*bn) > lim)){
				m = reduction(m);
				n = reduction(n);
			}
			an = m.num.as_u256();
			ad = m.den.as_u256();
			bn = n.num.as_u256();
			bd = n.den.as_u256();
			if ((ad*bd > lim) || ((an*bd + ad*bn) > lim)){
				let mut ddd = (an*bd + ad*bn)/(ad*bd);
				let mut factor: u64 = 1;
				let mut i: u8 = 1;
				while i < 5 {
					if ddd*10.as_u256() < lim {
						ddd *= 10.as_u256();
						factor *= 10;
					}
					i += 1;
				};
				let np256 = (((an*bd + ad*bn)*factor.as_u256())/(ad*bd));
				let np = u64::try_from(np256).unwrap();
				let fr = Fraction {
					sign: f1.sign,
					num: np,
					den: factor, 
				};
				return fr;
			}
			else {
				let fr = Fraction {
					sign: f1.sign,
					num: (m.num*n.den + n.num*m.den),
					den: m.den*n.den,
				};
				return fr;
			}
			
			
		}
		else {

			if ((an*bd) > (bn*ad)){
				if ((ad*bd > lim) || ((an*bd - ad*bn) > lim)){
					m = reduction(m);
					n = reduction(n);
				}
				an = m.num.as_u256();
				ad = m.den.as_u256();
				bn = n.num.as_u256();
				bd = n.den.as_u256();
				if ((ad*bd > lim) || ((an*bd - ad*bn) > lim)){
					let mut ddd = (an*bd - ad*bn)/(ad*bd);
					let mut factor: u64 = 1;
					let mut i: u8 = 1;
					while i < 5 {
						if ddd*10.as_u256() < lim {
							ddd *= 10.as_u256();
							factor *= 10;
						}
						i += 1;
					};
					let np256 = (((an*bd - ad*bn)*factor.as_u256())/(ad*bd));
					let np = u64::try_from(np256).unwrap();
					let fr = Fraction {
						sign: f1.sign,
						num: np,
						den: factor, 
					};
					fr
				}
				else {
					let fr = Fraction {
						sign: f1.sign,
						num: (m.num*n.den - n.num*m.den),
						den: m.den*n.den,
					};
					fr
				}
			}
			else {
				if ((ad*bd > lim) || ((bn*ad - bd*an) > lim)){
					m = reduction(m);
					n = reduction(n);
				}
				an = m.num.as_u256();
				ad = m.den.as_u256();
				bn = n.num.as_u256();
				bd = n.den.as_u256();
				if ((ad*bd > lim) || ((bn*ad - bd*an) > lim)){
					let mut ddd = (bn*ad - bd*an)/(ad*bd);
					let mut factor: u64 = 1;
					let mut i: u8 = 1;
					while i < 5 {
						if ddd*10.as_u256() < lim {
							ddd *= 10.as_u256();
							factor *= 10;
						}
						i += 1;
					};
					let np256 = (((bn*ad - bd*an)*factor.as_u256())/(ad*bd));
					let np = u64::try_from(np256).unwrap();
					let fr = Fraction {
						sign: f3.sign,
						num: np,
						den: factor, 
					};
					fr
				}
				else {
					let fr = Fraction {
						sign: f3.sign,
						num: (n.num*m.den - m.num*n.den),
						den: m.den*n.den,
					};
					fr
				}
			}
		}
	}

	// returns the approximate square root of the Fraction
	fn sqrt(x: Fraction) -> Fraction {
		assert((x.sign != false) || (x.num == 0));
		if x.num == 0 {
			x
		}
		else {
			let mut sqrt_approx = Fraction {
				sign: true,
				num: (x.num + 1)/2,
				den: x.den,
			};
			
			let p = x.num.as_u256();
			let q = x.den.as_u256();

			let mut c_init = sqrt_approx.num.as_u256();
			let mut d_init = sqrt_approx.den.as_u256();

			let mut c = c_init;
			let mut d = d_init;

			let mut i = 1;
			while i < 15 {
				c = (q*c_init*c_init + p*d_init*d_init);
				d = 2.as_u256()*q*c_init*d_init;
				c_init = (c*1000000.as_u256())/d;
				d_init = 1000000.as_u256();
				i += 1;
			}

			let fr = Fraction {
				sign: true,
				num: u64::try_from(c_init).unwrap(),
				den: 1000000,
			};
			fr  
		}
		
	}


	// Returns the closest but smaller Integer to the Given Fraction, but typecast to Fraction for convenience
	fn floor(f: Fraction) -> Fraction {
		let q = f.num/f.den;
		if (q * f.den == f.num){
			let fr = Fraction{
				sign: f.sign,
				num: f.num,
				den: f.den,
			};
			return fr;
		}
		else {
			if f.sign {
				let fr = Fraction{
					sign: f.sign,
					num: q,
					den: 1,
				};
				return fr;    
			}
			else {
				let fr = Fraction{
					sign: f.sign,
					num: q + 1,
					den: 1,
				};
				return fr; 
			}
			
		}
	}

	// Returns the closest but greater Integer to the Given Fraction, but typecast to Fraction for convenience
	fn ceiling(f: Fraction) -> Fraction {
		let q = f.num/f.den;
		if (q * f.den == f.num){
			let fr = Fraction{
				sign: f.sign,
				num: f.num,
				den: f.den,
			};
			return fr;
		}
		else {
			if f.sign {
				let fr = Fraction{
					sign: f.sign,
					num: q + 1,
					den: 1,
				};
				return fr;    
			}
			else {
				let fr = Fraction{
					sign: f.sign,
					num: q,
					den: 1,
				};
				return fr; 
			}
			
		}
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



#[test]
fn test_mul() {
    let f1 = Fraction::to(true, 1, 5);
    let f2 = Fraction::to(true, 5, 1);
    let f = Fraction::multiply(f1, f2);
    assert(f.num == f.den);
}


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

#[test]
fn test_approx() {
	let f = Fraction::to(true, 333333, 4444444);
	let fapprox = Fraction::approximate(f);

	assert (fapprox.num == 749);
	
}


#[test]
fn test_div() {
    let f1 = Fraction::to(true, 6, 5);
    let f2 = Fraction::to(true, 5, 1);
    let f = Fraction::divide(f1, f2);
    assert (f.num == 6);
    assert (f.den == 25);
}


#[test]
fn test_mul_large() {
	let f1 = Fraction::to(true, 33333333, 5);
	let f2 = Fraction::to(true, 500000, 77777);
	let m = Fraction::multiply(f1, f2);
	
	let p = m.num;
	let q = m.den;
	let lm = p/q;
	assert (lm == 42857571);

}


#[test]
fn test_compare() {
    let f1 = Fraction::to(true, 6, 10);
    let f2 = Fraction::to(true, 3, 5);
    let cmp = Fraction::compare(f1, f2);
    assert (cmp == 0);
    
}

#[test]
fn test_compare_zeros() {
    let f1 = Fraction::to(true, 0, 10);
    let f2 = Fraction::to(false, 0, 5);
    let cmp = Fraction::compare(f1, f2);
    assert (cmp == 0);
    
}

#[test]
fn test_sum() {
	let f1 = Fraction::to(true, 3, 5);
	let f2 = Fraction::to(true, 2, 5);
	let f = Fraction::add(f1, f2);
	assert (f.num == f.den);
}

#[test]
fn test_sum_negative() {
	let f1 = Fraction::to(true, 3, 5);
	let f2 = Fraction::to(false, 1, 5);
	let f = Fraction::add(f1, f2);
	let cmp = Fraction::compare(f, Fraction::to(true, 2,5));
	assert (cmp == 0);
	
}

#[test]
fn test_sum_large() {
	let f1 = Fraction::to(true, 33333333, 5);
	let f2 = Fraction::to(true, 500000, 33333333);
	let a = Fraction::add(f1, f2);
	
	assert (a.num <= 2000000000);
	assert (a.den <= 2000000000);
}

#[test]
fn test_diff() {
	let f1 = Fraction::to(true, 3, 5);
	let f2 = Fraction::to(true, 2, 5);
	let f = Fraction::subtract(f1, f2);
	let cmp = Fraction::compare(f, Fraction::to(true, 1,5));
	assert (cmp == 0);
	
}

#[test]
fn test_diff_negative() {
	let f1 = Fraction::to(true, 3, 5);
	let f2 = Fraction::to(false, 2, 5);
	let f = Fraction::subtract(f1, f2);
	let cmp = Fraction::compare(f, Fraction::to(true, 1,1));
	assert (cmp == 0);
	
}

#[test]
fn test_diff_large() {
	let f1 = Fraction::to(true, 33333333, 5);
	let f2 = Fraction::to(true, 500000, 33333333);
	let a = Fraction::subtract(f1, f2);
	
	assert (a.num <= 2000000000);
	assert (a.den <= 2000000000);
}


#[test]
fn test_floor() {
	let f = Fraction::to(true, 7, 5);
	let fl = Fraction::floor(f);
	assert (fl.num == 1);
	assert (fl.den == 1);
}

#[test]
fn test_floor2() {
	let f = Fraction::to(false, 12, 5);
	let fl = Fraction::floor(f);
	assert (fl.num == 3);
	assert (fl.den == 1);
}

#[test]
fn test_ceiling() {
	let f = Fraction::to(true, 7, 5);
	let ce = Fraction::ceiling(f);
	assert (ce.num == 2);
	assert (ce.den == 1);
}

#[test]
fn test_ceiling2() {
	let f = Fraction::to(false, 12, 5);
	let ce = Fraction::ceiling(f);
	assert (ce.num == 2);
	assert (ce.den == 1);
}

#[test]
fn test_sqrt1(){
    let f1 = Fraction::to(true, 3, 8);
    let sqrt = Fraction::sqrt(f1);
	let sq = Fraction::square(sqrt);
    let delta = Fraction::subtract(f1, sq);
    let epsilon = Fraction {
        sign: true,
        num: 1,
        den: 1000,
    };
    if !delta.sign {
        assert (Fraction::compare(epsilon, Fraction::reverse_sign(delta)) <= 1);
    }
    else {
        assert (Fraction::compare(epsilon, delta) <= 1);
    }
    
}

#[test]
fn test_sqrt2(){
    let f1 = Fraction::to(true, 99999, 444);
    let sqrt = Fraction::sqrt(f1);
    let delta = Fraction::subtract(f1, Fraction::square(sqrt));
    let epsilon = Fraction {
        sign: true,
        num: 1,
        den: 1000,
    };
    if !delta.sign {
        assert(Fraction::compare(epsilon, Fraction::reverse_sign(delta)) <= 1);
    }
    else {
        assert (Fraction::compare(epsilon, delta) <= 1);
    }
    
}