function I11m1 = kausel_11m1(a,b,c,mode)

switch mode
        
    case 'HP' % from table 4 Kausel
        
        A = sqrt((a+b).^2+c.^2);
        B = sqrt((a-b).^2+c.^2);
        L1 = 1/2*(A-B);
        L2 = 1/2*(A+B);
        k  = L1./L2;
        nab = k.*a./b;
        nba = k.*b./a;

        K   = EllipticK(k);
        E   = EllipticE(k);
        Pab = EllipticPi(nab(a<=b),k(a<=b));
        Pba = EllipticPi(nba(a>b),k(a>b));
        
        I11m1 = c./(pi*L1).*( E - K );
        I11m1(a<=b) = I11m1(a<=b) + c(a<=b)./(pi*L1(a<=b)).*( b(a<=b).^2./L2(a<=b).^2.*(Pab-K(a<=b)) + a(a<=b).^2./L2(a<=b).^2.*( pi*L2(a<=b)./(2*c(a<=b)) - Pab ) );
        I11m1(a>b)  = I11m1(a>b) + c(a>b)./(pi*L1(a>b)).*( a(a>b).^2./L2(a>b).^2.*(Pba-K(a>b)) + b(a>b).^2./L2(a>b).^2.*( pi*L2(a>b)./(2*c(a>b)) - Pba ) );
        
    otherwise % from table 3 Kausel - ENS-4.9
        
        k    = 2*sqrt(a.*b)./sqrt((a+b).^2+c.^2);
        beta = asin(sqrt(c.^2./((a-b).^2+c.^2)));
        
        K = EllipticK(k);
        E = EllipticE(k);
        L = pi/2*HeumanLambda(beta,k);
        
        I11m1 = c./(pi*sqrt(a.*b)).*( 1./k.*E - (a.^2+b.^2+c.^2/2).*k./(2*a.*b).*K ) + ...
                1./(4*a.*b).*( a.^2+b.^2+(a.^2-b.^2).*sign(a-b).*(2/pi*L-1) );
    
end