function grid = barkgrid(b,v)

    x=ceil(b);
    grid=repmat(min(v),size(x));
    grid(1)=1;
    maximum=max(v);
    for i=2:length(x)
        if(x(i)~=x(i-1))
            grid(i)=maximum;
        end
    end
end